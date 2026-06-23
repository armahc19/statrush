from flask import Blueprint, jsonify, request
from services.team_stats import update_team_stats
from services.player_stats import rebuild_player_stats
from auth import token_required, admin_required
from .system_process_event import (  # Import all functions
    update_player_stats,
    calculate_match_result,
    update_match_results,
    update_team_stats,
    update_fixture_status,
    recalculate_rankings
)
from db import get_conn
#from import_data import run_import
import logging
logger = logging.getLogger(__name__)
from services import bing_events_extract

#import logging                     # ← NEW
#logger = logging.getLogger(__name__)   # ← NEW

stats_bp = Blueprint("stats_bp", __name__)

# -----------------------------
# RECOMPUTE TEAM STATS
# -----------------------------
@stats_bp.route("/recompute/team-stats", methods=["POST"])
def recompute_team_stats():
    try:
        update_team_stats()
        return jsonify({
            "status": "success",
            "message": "Team stats recomputed"
        }), 200
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


# -----------------------------
# RECOMPUTE PLAYER STATS
# -----------------------------
@stats_bp.route("/recompute/player-stats", methods=["POST"])
def recompute_player_stats():
    try:
        rebuild_player_stats()
        return jsonify({
            "status": "success",
            "message": "Player stats recomputed"
        }), 200
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


# -----------------------------
# GET TEAM STATS
# -----------------------------

@stats_bp.route("/team-stats", methods=["GET"])
def get_team_stats():
    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 5))
    offset = (page - 1) * size

    conn = get_conn()
    cur = conn.cursor()

    # total count
    cur.execute("SELECT COUNT(*) FROM team_stats")
    total_teams = cur.fetchone()[0]

    cur.execute("""
        SELECT team_name, goals_scored, goals_conceded, wins, losses, draws, matches_played
        FROM team_stats
        ORDER BY (wins * 3 + draws) DESC, (goals_scored - goals_conceded) DESC, goals_scored DESC
        LIMIT %s OFFSET %s
    """, (size, offset))

    rows = cur.fetchall()
    cur.close()
    conn.close()

    flag_map = {
        "Algeria": "🇩🇿",
        "Argentina": "🇦🇷",
        "Australia": "🇦🇺",
        "Austria": "🇦🇹",
        "Belgium": "🇧🇪",
        "Bosnia and Herzegovina": "🇧🇦",
        "Bosnia-Herzegovina": "🇧🇦",
        "Brazil": "🇧🇷",
        "Cabo Verde": "🇨🇻",
        "Canada": "🇨🇦",
        "Cape Verde Islands": "🇨🇻",
        "Colombia": "🇨🇴",
        "Congo DR": "🇨🇩",
        "Croatia": "🇭🇷",
        "Curaçao": "🇨🇼",
        "Czechia": "🇨🇿",
        "DR Congo": "🇨🇩",
        "Ecuador": "🇪🇨",
        "Egypt": "🇪🇬",
        "England": "🏴",
        "France": "🇫🇷",
        "Germany": "🇩🇪",
        "Ghana": "🇬🇭",
        "Haiti": "🇭🇹",
        "Iran": "🇮🇷",
        "Iraq": "🇮🇶",
        "Italy": "🇮🇹",
        "Ivory Coast": "🇨🇮",
        "Japan": "🇯🇵",
        "Jordan": "🇯🇴",
        "Mexico": "🇲🇽",
        "Morocco": "🇲🇦",
        "Netherlands": "🇳🇱",
        "New Zealand": "🇳🇿",
        "Norway": "🇳🇴",
        "Panama": "🇵🇦",
        "Paraguay": "🇵🇾",
        "Portugal": "🇵🇹",
        "Qatar": "🇶🇦",
        "Saudi Arabia": "🇸🇦",
        "Scotland": "🏴",
        "Senegal": "🇸🇳",
        "South Africa": "🇿🇦",
        "South Korea": "🇰🇷",
        "Spain": "🇪🇸",
        "Sweden": "🇸🇪",
        "Switzerland": "🇨🇭",
        "Tunisia": "🇹🇳",
        "Turkey": "🇹🇷",
        "Türkiye": "🇹🇷",
        "United States": "🇺🇸",
        "Uruguay": "🇺🇾",
        "USA": "🇺🇸",
        "Uzbekistan": "🇺🇿"
    }

    groups_map = {
        "France": "A", "Argentina": "A", "Mexico": "A", "Canada": "A",
        "Brazil": "B", "Spain": "B", "Japan": "B", "Morocco": "B",
        "England": "C", "Germany": "C", "Portugal": "C", "USA": "C", "United States": "C",
        "Netherlands": "D", "Uruguay": "D", "Italy": "D", "Belgium": "D", "Croatia": "D"
    }

    result = []

    for idx, r in enumerate(rows):
        team = r[0]
        gf = r[1] or 0
        ga = r[2] or 0
        wins = r[3] or 0
        losses = r[4] or 0
        draws = r[5] or 0
        played = r[6] or 0

        flag = flag_map.get(team, "🏳️")
        group = groups_map.get(team, "A")
        points = wins * 3 + draws
        gd = gf - ga

        rating = 70.0 + (points * 3.0) + (gd * 0.5)
        rating = max(50.0, min(99.0, rating))

        form = (["W"] * wins + ["D"] * draws + ["L"] * losses)[:3]
        if not form:
            form = ["D"]

        rank = offset + idx + 1

        prev_rank = rank + 1 if gd > 0 else (rank - 1 if gd < 0 else rank)
        prev_rank = max(1, prev_rank)

        trend = "same"
        if rank < prev_rank:
            trend = "up"
        elif rank > prev_rank:
            trend = "down"

        result.append({
            "rank": rank,
            "prevRank": prev_rank,
            "team": team,
            "flag": flag,
            "group": group,
            "played": played,
            "wins": wins,
            "draws": draws,
            "losses": losses,
            "gf": gf,
            "ga": ga,
            "gd": gd,
            "points": points,
            "rating": rating,
            "trend": trend,
            "form": form
        })

    return jsonify({
        "page": page,
        "size": size,
        "total": total_teams,
        "teams": result
    })


# -----------------------------
# GET PLAYER STATS
# ----------------------------- 

@stats_bp.route("/player-stats", methods=["GET"])
def get_player_stats():
    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 5))
    offset = (page - 1) * size

    conn = get_conn()
    cur = conn.cursor()

    # total count
    cur.execute("SELECT COUNT(*) FROM players WHERE team_name IS NOT NULL")
    total_players = cur.fetchone()[0]

    cur.execute("""
        SELECT id, name, position, team_name, goals, yellow_cards, red_cards, points,assists
        FROM players
        WHERE team_name IS NOT NULL
        ORDER BY points DESC, goals DESC, assists DESC, name ASC
        LIMIT %s OFFSET %s
    """, (size, offset))

    rows = cur.fetchall()
    cur.close()
    conn.close()

    result = []

    for idx, r in enumerate(rows):
        pid = str(r[0])
        name = r[1]
        db_pos = r[2]
        team = r[3]
        goals = r[4] or 0
        yellow = r[5] or 0
        red = r[6] or 0
        points = r[7] or 0
        assists = r[8] or 0
        pos_map = {
            "Goalkeeper": "GK",
            "Defence": "DF",
            "Midfield": "MF",
            "Offence": "FW"
        }

        position = pos_map.get(db_pos, "FW")

        flag_map = {
            "Algeria": "🇩🇿",
            "Argentina": "🇦🇷",
            "Australia": "🇦🇺",
            "Austria": "🇦🇹",
            "Belgium": "🇧🇪",
            "Bosnia and Herzegovina": "🇧🇦",
            "Bosnia-Herzegovina": "🇧🇦",
            "Brazil": "🇧🇷",
            "Cabo Verde": "🇨🇻",
            "Canada": "🇨🇦",
            "Cape Verde Islands": "🇨🇻",
            "Colombia": "🇨🇴",
            "Congo DR": "🇨🇩",
            "Croatia": "🇭🇷",
            "Curaçao": "🇨🇼",
            "Czechia": "🇨🇿",
            "DR Congo": "🇨🇩",
            "Ecuador": "🇪🇨",
            "Egypt": "🇪🇬",
            "England": "🏴",
            "France": "🇫🇷",
            "Germany": "🇩🇪",
            "Ghana": "🇬🇭",
            "Haiti": "🇭🇹",
            "Iran": "🇮🇷",
            "Iraq": "🇮🇶",
            "Italy": "🇮🇹",
            "Ivory Coast": "🇨🇮",
            "Japan": "🇯🇵",
            "Jordan": "🇯🇴",
            "Mexico": "🇲🇽",
            "Morocco": "🇲🇦",
            "Netherlands": "🇳🇱",
            "New Zealand": "🇳🇿",
            "Norway": "🇳🇴",
            "Panama": "🇵🇦",
            "Paraguay": "🇵🇾",
            "Portugal": "🇵🇹",
            "Qatar": "🇶🇦",
            "Saudi Arabia": "🇸🇦",
            "Scotland": "🏴",
            "Senegal": "🇸🇳",
            "South Africa": "🇿🇦",
            "South Korea": "🇰🇷",
            "Spain": "🇪🇸",
            "Sweden": "🇸🇪",
            "Switzerland": "🇨🇭",
            "Tunisia": "🇹🇳",
            "Turkey": "🇹🇷",
            "Türkiye": "🇹🇷",
            "United States": "🇺🇸",
            "Uruguay": "🇺🇾",
            "USA": "🇺🇸",
            "Uzbekistan": "🇺🇿"
        }

        flag = flag_map.get(team, "🏳️")

        score = 5.0 + (points * 0.2)
        score = max(5.0, min(9.9, score))

        momentum = [
            round(score - 0.8, 1),
            round(score - 0.5, 1),
            round(score - 0.2, 1),
            round(score - 0.1, 1),
            round(score, 1)
        ]

        if points > 15:
            trend = "fire"
            trend_val = "+3"
        elif points > 8:
            trend = "up"
            trend_val = "+1"
        elif points > 0:
            trend = "same"
            trend_val = "0"
        else:
            trend = "cool"
            trend_val = "-1"

        result.append({
            "rank": offset + idx + 1,
            "id": pid,
            "name": name,
            "team": team,
            "flag": flag,
            "position": position,
            "score": score,
            "trend": trend,
            "trendValue": trend_val,
            "goals": goals,
            "assists": assists,
            "cards": yellow + red,
            "minutes": 360 if points > 0 else 0,
            "matches": 4 if points > 0 else 0,
            "yellow": yellow,
            "red": red,
            "momentum": momentum
        })

    return jsonify({
        "page": page,
        "size": size,
        "total": total_players,
        "players": result
    })


# -----------------------------
# GET MATCHES
# -----------------------------
@stats_bp.route("/matches", methods=["GET"])
def get_matches():
    # Get pagination parameters
    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 10))
    offset = (page - 1) * size

    conn = get_conn()
    cur = conn.cursor()

    # Fetch total count for metadata
    cur_total = conn.cursor()
    cur_total.execute("SELECT COUNT(*) FROM match_results")
    total_matches = cur_total.fetchone()[0]
    cur_total.close()

    # Flag map for team emojis (same as used in other endpoints)
    flag_map = {
    "Algeria": "🇩🇿",
    "Argentina": "🇦🇷",
    "Australia": "🇦🇺",
    "Austria": "🇦🇹",
    "Belgium": "🇧🇪",
    "Bosnia and Herzegovina": "🇧🇦",
    "Bosnia-Herzegovina": "🇧🇦",
    "Brazil": "🇧🇷",
    "Cabo Verde": "🇨🇻",
    "Canada": "🇨🇦",
    "Cape Verde Islands": "🇨🇻",
    "Colombia": "🇨🇴",
    "Congo DR": "🇨🇩",
    "Croatia": "🇭🇷",
    "Curaçao": "🇨🇼",
    "Czechia": "🇨🇿",
    "DR Congo": "🇨🇩",
    "Ecuador": "🇪🇨",
    "Egypt": "🇪🇬",
    "England": "🏴󠁧󠁢󠁥󠁮󠁧󠁿",
    "France": "🇫🇷",
    "Germany": "🇩🇪",
    "Ghana": "🇬🇭",
    "Haiti": "🇭🇹",
    "Iran": "🇮🇷",
    "Iraq": "🇮🇶",
    "Italy": "🇮🇹",
    "Ivory Coast": "🇨🇮",
    "Japan": "🇯🇵",
    "Jordan": "🇯🇴",
    "Mexico": "🇲🇽",
    "Morocco": "🇲🇦",
    "Netherlands": "🇳🇱",
    "New Zealand": "🇳🇿",
    "Norway": "🇳🇴",
    "Panama": "🇵🇦",
    "Paraguay": "🇵🇾",
    "Portugal": "🇵🇹",
    "Qatar": "🇶🇦",
    "Saudi Arabia": "🇸🇦",
    "Scotland": "🏴󠁧󠁢󠁳󠁣󠁴󠁿",
    "Senegal": "🇸🇳",
    "South Africa": "🇿🇦",
    "South Korea": "🇰🇷",
    "Spain": "🇪🇸",
    "Sweden": "🇸🇪",
    "Switzerland": "🇨🇭",
    "Tunisia": "🇹🇳",
    "Turkey": "🇹🇷",
    "Türkiye": "🇹🇷",
    "United States": "🇺🇸",
    "Uruguay": "🇺🇾",
    "USA": "🇺🇸",
    "Uzbekistan": "🇺🇿"
}



    # Fetch paginated match results
    cur.execute("""
        SELECT event_id, home_team, away_team, home_score, away_score, result
        FROM match_results
        ORDER BY event_id ASC
        LIMIT %s OFFSET %s
    """, (size, offset))
    rows = cur.fetchall()
    result = []
    for r in rows:
        event_id = r[0]
        home = r[1]
        away = r[2]
        home_score = r[3]
        away_score = r[4]

        cur.execute("""
            SELECT id, event_type, minute, team_name, player_name
            FROM match_events
            WHERE team_name = %s OR team_name = %s
            ORDER BY minute ASC
        """, (home, away))
        event_rows = cur.fetchall()

        events = []
        for e in event_rows:
            e_id = e[0]
            e_type = e[1]
            minute = e[2]
            team = e[3]
            player = e[4]

            icon = "⚽"
            text = f"Goal — {player} ({team})"
            if e_type == "YELLOW_CARD":
                icon = "🟨"
                text = f"Yellow Card — {player} ({team})"
            elif e_type == "RED_CARD":
                icon = "🟥"
                text = f"Red Card — {player} ({team})"

            events.append({
                "id": e_id,
                "minute": f"{minute}'",
                "icon": icon,
                "text": text
            })

        result.append({
            "id": str(event_id),
            "home": home,
            "homeFlag": flag_map.get(home, "🏳️"),
            "away": away,
            "awayFlag": flag_map.get(away, "🏳️"),
            "status": "played",
            "scoreHome": home_score,
            "scoreAway": away_score,
            "minute": "90'",
            "date": "Jun 12",
            "time": "18:00",
            "venue": "MetLife Stadium",
            "group": "Group A",
            "events": events
        })

    # Fetch upcoming fixtures from DB
    upcoming = []
    try:
        cur_up = conn.cursor()
        cur_up.execute("""
            SELECT fixture_id, home_team, away_team, date, time, venue, group_name
            FROM upcoming_fixtures
            ORDER BY date ASC, time ASC
        """)
        upcoming_rows = cur_up.fetchall()
        for f_id, home, away, f_date, f_time, venue, grp in upcoming_rows:
            upcoming.append({
                "id": f"up-{f_id}",
                "home": home,
                "homeFlag": flag_map.get(home, "🏳️"),
                "away": away,
                "awayFlag": flag_map.get(away, "🏳️"),
                "status": "upcoming",
                "date": f_date.strftime("%b %d") if hasattr(f_date, 'strftime') else str(f_date),
                "time": f_time.strftime("%H:%M") if hasattr(f_time, 'strftime') else str(f_time),
                "venue": venue,
                "group": grp,
                "events": []
            })
        cur_up.close()
    except Exception as e:
        logger.exception("Failed to fetch upcoming fixtures: %s", e)
        # fallback to empty list
        upcoming = []


    for idx, f in enumerate(upcoming):
        result.append({
            "id": f"up-{idx}",
            "home": f["home"],
            "homeFlag": flag_map.get(f["home"], "🏳️"),
            "away": f["away"],
            "awayFlag": flag_map.get(f["away"], "🏳️"),
            "status": "upcoming",
            "date": f["date"],
            "time": f["time"],
            "venue": f["venue"],
            "group": f["group"],
            "events": []
        })

    cur.close()
    conn.close()
    # Return pagination metadata along with matches
    return jsonify({
        "page": page,
        "size": size,
        "total": total_matches,
        "matches": result
    })

@stats_bp.route("/fixtures", methods=["GET"])
def get_fixtures():
    page = int(request.args.get('page', 1))
    size = int(request.args.get('size', 10))
    offset = (page - 1) * size

    conn = get_conn()
    cur = conn.cursor()

    # total count
    cur.execute("SELECT COUNT(*) FROM fixtures")
    total_fixtures = cur.fetchone()[0]

    flag_map = {
    "Algeria": "🇩🇿",
    "Argentina": "🇦🇷",
    "Australia": "🇦🇺",
    "Austria": "🇦🇹",
    "Belgium": "🇧🇪",
    "Bosnia and Herzegovina": "🇧🇦",
    "Bosnia-Herzegovina": "🇧🇦",
    "Brazil": "🇧🇷",
    "Cabo Verde": "🇨🇻",
    "Canada": "🇨🇦",
    "Cape Verde Islands": "🇨🇻",
    "Colombia": "🇨🇴",
    "Congo DR": "🇨🇩",
    "Croatia": "🇭🇷",
    "Curaçao": "🇨🇼",
    "Czechia": "🇨🇿",
    "DR Congo": "🇨🇩",
    "Ecuador": "🇪🇨",
    "Egypt": "🇪🇬",
    "England": "🏴󠁧󠁢󠁥󠁮󠁧󠁿",
    "France": "🇫🇷",
    "Germany": "🇩🇪",
    "Ghana": "🇬🇭",
    "Haiti": "🇭🇹",
    "Iran": "🇮🇷",
    "Iraq": "🇮🇶",
    "Italy": "🇮🇹",
    "Ivory Coast": "🇨🇮",
    "Japan": "🇯🇵",
    "Jordan": "🇯🇴",
    "Mexico": "🇲🇽",
    "Morocco": "🇲🇦",
    "Netherlands": "🇳🇱",
    "New Zealand": "🇳🇿",
    "Norway": "🇳🇴",
    "Panama": "🇵🇦",
    "Paraguay": "🇵🇾",
    "Portugal": "🇵🇹",
    "Qatar": "🇶🇦",
    "Saudi Arabia": "🇸🇦",
    "Scotland": "🏴󠁧󠁢󠁳󠁣󠁴󠁿",
    "Senegal": "🇸🇳",
    "South Africa": "🇿🇦",
    "South Korea": "🇰🇷",
    "Spain": "🇪🇸",
    "Sweden": "🇸🇪",
    "Switzerland": "🇨🇭",
    "Tunisia": "🇹🇳",
    "Turkey": "🇹🇷",
    "Türkiye": "🇹🇷",
    "United States": "🇺🇸",
    "Uruguay": "🇺🇾",
    "USA": "🇺🇸",
    "Uzbekistan": "🇺🇿"
}


    cur.execute("""
        SELECT id, home_team, away_team, group_name, stage,
               matchday, kickoff_time, status
        FROM fixtures
        ORDER BY kickoff_time ASC
        LIMIT %s OFFSET %s
    """, (size, offset))

    rows = cur.fetchall()

    fixtures = []
    for fid, home, away, group, stage, matchday, kickoff, status in rows:
        fixtures.append({
            "id": fid,
            "home": home,
            "homeFlag": flag_map.get(home, "🏳️"),
            "away": away,
            "awayFlag": flag_map.get(away, "🏳️"),
            "group": group,
            "stage": stage,
            "matchday": matchday,
            "date": kickoff.strftime("%b %d") if kickoff else None,
            "time": kickoff.strftime("%H:%M") if kickoff else None,
            "status": status,
            "events": []
        })

    cur.close()
    conn.close()

    return jsonify({
        "page": page,
        "size": size,
        "total": total_fixtures,
        "fixtures": fixtures
    })
# -----------------------------
# IMPORT DATA FROM BZZOIRO API
# -----------------------------
@stats_bp.route("/import", methods=["POST"])
def import_data_route():
    try:
        run_import()
        return jsonify({"status": "success", "message": "Data imported from Bzzoiro API"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# -----------------------------
# BULK EVENT SUBMISSION (Protected - Admin Only)
# -----------------------------
@stats_bp.route("/events/bulk", methods=["POST"])
@admin_required
def bulk_events():
    """Submit multiple match events at once"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({
                "status": "error",
                "message": "Missing request data"
            }), 400
        
        # Check if data is the new format with match_id
        if 'match_id' in data and 'events' in data:
            match_id = data.get('match_id')
            events = data.get('events', [])
            
            if not match_id:
                return jsonify({
                    "status": "error",
                    "message": "Match ID is required"
                }), 400
                
            if not events or not isinstance(events, list):
                return jsonify({
                    "status": "error",
                    "message": "Expected array of events"
                }), 400
            
            # Start transaction
            conn = get_conn()
            cur = conn.cursor()
            
            try:
                # 1. Verify fixture exists
                cur.execute("SELECT id, home_team, away_team FROM fixtures WHERE id = %s", (match_id,))
                fixture = cur.fetchone()
                if not fixture:
                    cur.close()
                    conn.close()
                    return jsonify({
                        "status": "error",
                        "message": "Fixture not found"
                    }), 404
                
                fixture_id = fixture[0]
                home_team = fixture[1]
                away_team = fixture[2]
                
                # 2. Delete existing events for this fixture (if any)
                cur.execute("DELETE FROM match_events WHERE match_id = %s", (match_id,))
                
                # 3. Insert events and update player stats
                for event in events:
                    event_type_map = {
                        "Goal ⚽": "GOAL",
                        "Assist 🎯": "ASSIST",
                        "Yellow Card 🟨": "YELLOW_CARD",
                        "Red Card 🟥": "RED_CARD"
                    }
                    
                    cur.execute("""
                        INSERT INTO match_events 
                        (match_id, event_type, player_name, team_name, minute, created_at)
                        VALUES (%s, %s, %s, %s, %s, NOW())
                    """, (
                        match_id,
                        event_type_map.get(event.get('type'), 'GOAL'),
                        event.get('player'),
                        event.get('team'),
                        event.get('minute')
                    ))
                    
                    # Update player stats for each event
                    update_player_stats(cur, event)
                
                # 4. Calculate match result
                result_data = calculate_match_result(events, home_team, away_team)
                
                # 5. Update match results
                """ update_match_results(
                        cur, 
                        match_id, 
                        result_data['home_score'], 
                        result_data['away_score'],
                        result_data['result'], 
                        result_data['winner']
                    )"""
                # In bulk_events function, after getting fixture data:
                # In bulk_events function, after getting fixture data:

                # In bulk_events function, after getting fixture data:
                fixture_id = fixture[0]
                home_team = fixture[1]
                away_team = fixture[2]

                # Then when calling update_match_results:
                update_match_results(
                    cur, 
                    match_id, 
                    home_team,      # Pass home_team
                    away_team,      # Pass away_team
                    result_data['home_score'], 
                    result_data['away_score'],
                    result_data['result'], 
                    result_data['winner']
                )
                
                # 6. Update team stats
                # Update home team
                update_team_stats(
                    cur,
                    home_team,
                    result_data['home_score'],
                    result_data['away_score'],
                    "WIN" if result_data['result'] == "HOME_WIN" else "LOSS" if result_data['result'] == "AWAY_WIN" else "DRAW"
                )
                
                # Update away team
                update_team_stats(
                    cur,
                    away_team,
                    result_data['away_score'],
                    result_data['home_score'],
                    "WIN" if result_data['result'] == "AWAY_WIN" else "LOSS" if result_data['result'] == "HOME_WIN" else "DRAW"
                )
                
                # 7. Update fixture status
                update_fixture_status(cur, match_id, "completed")
                
                # 8. Recalculate rankings
                recalculate_rankings(cur)
                
                # Commit all changes
                conn.commit()
                cur.close()
                conn.close()
                
                return jsonify({
                    "status": "success",
                    "message": f"Successfully processed {len(events)} events for fixture {match_id}",
                    "data": {
                        "home_team": home_team,
                        "away_team": away_team,
                        "home_score": result_data['home_score'],
                        "away_score": result_data['away_score'],
                        "result": result_data['result'],
                        "winner": result_data['winner'],
                        "events_processed": len(events)
                    }
                }), 200
                
            except Exception as e:
                # Rollback on error
                conn.rollback()
                cur.close()
                conn.close()
                logger.exception("Error processing events")
                return jsonify({
                    "status": "error",
                    "message": f"Failed to process events: {str(e)}"
                }), 500
        
        # Fallback: Handle old format (array of events)
        elif isinstance(data, list):
            conn = get_conn()
            cur = conn.cursor()
            
            try:
                for event in data:
                    event_type_map = {
                        "Goal ⚽": "GOAL",
                        "Assist 🎯": "ASSIST",
                        "Yellow Card 🟨": "YELLOW_CARD",
                        "Red Card 🟥": "RED_CARD"
                    }
                    
                    cur.execute("""
                        INSERT INTO match_events 
                        (event_type, player_name, team_name, minute, created_at)
                        VALUES (%s, %s, %s, %s, NOW())
                    """, (
                        event_type_map.get(event.get('type'), 'GOAL'),
                        event.get('player'),
                        event.get('team'),
                        event.get('minute')
                    ))
                    
                    # Update player stats
                    update_player_stats(cur, event)
                
                conn.commit()
                cur.close()
                conn.close()
                
                return jsonify({
                    "status": "success",
                    "message": f"Submitted {len(data)} events"
                }), 200
                
            except Exception as e:
                conn.rollback()
                cur.close()
                conn.close()
                logger.exception("Error processing events")
                return jsonify({
                    "status": "error",
                    "message": f"Failed to process events: {str(e)}"
                }), 500
        
        else:
            return jsonify({
                "status": "error",
                "message": "Invalid data format. Expected object with match_id and events, or array of events"
            }), 400
        
    except Exception as e:
        logger.exception("Error in bulk events endpoint")
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

# -----------------------------
# SEARCH MATCHES
# -----------------------------
@stats_bp.route("/matches/search", methods=["GET"])
@admin_required
def search_matches():
    """Search for matches by team name or event_id"""
    query = request.args.get('q', '').strip()
    
    if not query:
        return jsonify({
            "status": "error",
            "message": "Search query is required"
        }), 400
    
    try:
        conn = get_conn()
        cur = conn.cursor()
        
        # Search by team name or event_id (case-insensitive)
        search_term = f"%{query}%"
        
        cur.execute("""
            SELECT 
                id,
                event_id,
                home_team,
                away_team,
                home_score,
                away_score,
                result,
                winner_team,
                created_at
            FROM match_results
            WHERE 
                LOWER(home_team) LIKE LOWER(%s)
                OR LOWER(away_team) LIKE LOWER(%s)
                OR CAST(event_id AS TEXT) LIKE %s
            ORDER BY created_at DESC
            LIMIT 20
        """, (search_term, search_term, search_term))
        
        rows = cur.fetchall()
        
        matches = []
        for row in rows:
            matches.append({
                "id": row[0],
                "event_id": row[1],
                "home_team": row[2],
                "away_team": row[3],
                "home_score": row[4],
                "away_score": row[5],
                "result": row[6],
                "winner_team": row[7],
                "created_at": row[8].isoformat() if row[8] else None
            })
        
        cur.close()
        conn.close()
        
        return jsonify({
            "status": "success",
            "count": len(matches),
            "matches": matches
        }), 200
        
    except Exception as e:
        logger.exception("Error searching matches")
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@stats_bp.route("/matches/live-search", methods=["GET"])
@admin_required
def live_search_matches():
    """Live search fixtures as user types"""
    query = request.args.get('q', '').strip()
    
    if not query or len(query) < 2:  # Only search if at least 2 characters
        return jsonify({
            "status": "success",
            "matches": []
        }), 200
    
    try:
        conn = get_conn()
        cur = conn.cursor()
        
        # Search by team name (case-insensitive)
        search_term = f"%{query}%"
        
        cur.execute("""
            SELECT 
                id,
                home_team,
                away_team,
                group_name,
                stage,
                matchday,
                kickoff_time,
                status,
                created_at
            FROM fixtures
            WHERE 
                LOWER(home_team) LIKE LOWER(%s)
                OR LOWER(away_team) LIKE LOWER(%s)
            ORDER BY 
                CASE 
                    WHEN LOWER(home_team) LIKE LOWER(%s) THEN 1
                    WHEN LOWER(away_team) LIKE LOWER(%s) THEN 2
                    ELSE 3
                END,
                kickoff_time ASC
            LIMIT 10
        """, (search_term, search_term, f"{query}%", f"{query}%"))
        
        rows = cur.fetchall()
        
        matches = []
        for row in rows:
            matches.append({
                "id": row[0],
                "home_team": row[1],
                "away_team": row[2],
                "group_name": row[3],
                "stage": row[4],
                "matchday": row[5],
                "kickoff_time": row[6].isoformat() if row[6] else None,
                "status": row[7],
                "created_at": row[8].isoformat() if row[8] else None,
                "display": f"{row[1]} vs {row[2]}"
            })
        
        cur.close()
        conn.close()
        
        return jsonify({
            "status": "success",
            "matches": matches
        }), 200
        
    except Exception as e:
        logger.exception("Error in live search")
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

# -----------------------------
# GET MATCH BY ID
# -----------------------------
@stats_bp.route("/matches/<int:match_id>", methods=["GET"])
@admin_required
def get_match_by_id(match_id):
    """Get a specific match by ID"""
    try:
        conn = get_conn()
        cur = conn.cursor()
        
        cur.execute("""
            SELECT 
                id,
                event_id,
                home_team,
                away_team,
                home_score,
                away_score,
                result,
                winner_team,
                created_at
            FROM match_results
            WHERE id = %s
        """, (match_id,))
        
        row = cur.fetchone()
        cur.close()
        conn.close()
        
        if not row:
            return jsonify({
                "status": "error",
                "message": "Match not found"
            }), 404
        
        match = {
            "id": row[0],
            "event_id": row[1],
            "home_team": row[2],
            "away_team": row[3],
            "home_score": row[4],
            "away_score": row[5],
            "result": row[6],
            "winner_team": row[7],
            "created_at": row[8].isoformat() if row[8] else None
        }
        
        return jsonify({
            "status": "success",
            "match": match
        }), 200
        
    except Exception as e:
        logger.exception("Error fetching match")
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

# -----------------------------
# GET MATCH EVENTS
# -----------------------------
@stats_bp.route("/matches/<int:match_id>/events", methods=["GET"])
@admin_required
def get_match_events(match_id):
    """Get all events for a specific match"""
    try:
        conn = get_conn()
        cur = conn.cursor()
        
        # First, get the match details
        cur.execute("""
            SELECT event_id, home_team, away_team
            FROM match_results
            WHERE id = %s
        """, (match_id,))
        
        match_row = cur.fetchone()
        if not match_row:
            cur.close()
            conn.close()
            return jsonify({
                "status": "error",
                "message": "Match not found"
            }), 404
        
        event_id = match_row[0]
        home_team = match_row[1]
        away_team = match_row[2]
        
        # Get all events for this match
        cur.execute("""
            SELECT 
                id,
                event_type,
                minute,
                team_name,
                player_name,
                created_at
            FROM match_events
            WHERE team_name IN (%s, %s)
            ORDER BY minute ASC
        """, (home_team, away_team))
        
        event_rows = cur.fetchall()
        
        events = []
        for row in event_rows:
            event_type = row[1]
            minute = row[2]
            
            # Map event type to display
            type_map = {
                'GOAL': '⚽ Goal',
                'YELLOW_CARD': '🟨 Yellow Card',
                'RED_CARD': '🟥 Red Card',
                'ASSIST': '🎯 Assist'
            }
            
            events.append({
                "id": row[0],
                "type": type_map.get(event_type, event_type),
                "minute": minute,
                "team": row[3],
                "player": row[4],
                "created_at": row[5].isoformat() if row[5] else None
            })
        
        cur.close()
        conn.close()
        
        return jsonify({
            "status": "success",
            "match_id": match_id,
            "event_id": event_id,
            "home_team": home_team,
            "away_team": away_team,
            "events": events
        }), 200
        
    except Exception as e:
        logger.exception("Error fetching match events")
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


# -----------------------------
# SCRAPE BING EVENTS
# -----------------------------
@stats_bp.route("/scrape/bing-events", methods=["POST"])
@admin_required
def scrape_bing_events():
    """
    Scrape match events from a Bing SportsDetails URL.
    
    Expects JSON:
    {
        "url": "https://www.bing.com/sportsdetails?q=...",
        "home_team": "France",
        "away_team": "Iraq"
    }
    
    Returns mapped events ready for frontend display.
    """
    try:
        from services.bing_event_mapper import scrape_and_map
        
        data = request.get_json()
        if not data:
            return jsonify({
                "status": "error",
                "message": "Missing request data"
            }), 400
        
        url = data.get("url", "").strip()
        home_team = data.get("home_team", "").strip()
        away_team = data.get("away_team", "").strip()
        
        # Validate inputs
        if not url:
            return jsonify({
                "status": "error",
                "message": "Bing URL is required"
            }), 400
        
        if not home_team or not away_team:
            return jsonify({
                "status": "error",
                "message": "Both home_team and away_team are required"
            }), 400
        
        if "bing.com/sportsdetails" not in url:
            return jsonify({
                "status": "error",
                "message": "Invalid URL. Must be a Bing SportsDetails URL"
            }), 400
        
        logger.info(f"Scraping Bing events for {home_team} vs {away_team}")
        
        # Call the scraper
        result = scrape_and_map(url, home_team, away_team)
        
        logger.info(
            f"Bing scrape complete: {result['total_found']} found, "
            f"{result['total_mapped']} mapped, "
            f"{len(result['skipped'])} skipped"
        )
        
        return jsonify(result), 200
        
    except ImportError as e:
        logger.exception("Failed to import bing_event_mapper")
        return jsonify({
            "status": "error",
            "message": "Bing scraper module not available. Ensure services/bing_event_mapper.py exists."
        }), 500
        
    except Exception as e:
        logger.exception("Error scraping Bing events")
        return jsonify({
            "status": "error",
            "message": f"Failed to scrape Bing events: {str(e)}"
        }), 500