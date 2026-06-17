from db import get_conn

def update_team_stats():
    conn = get_conn()
    cur = conn.cursor()

    # 1. Seed teams into team_stats if they don't exist
    cur.execute("SELECT name FROM teams")
    all_teams = cur.fetchall()
    for (team_name,) in all_teams:
        cur.execute("SELECT 1 FROM team_stats WHERE team_name = %s", (team_name,))
        if not cur.fetchone():
            cur.execute("""
                INSERT INTO team_stats (team_name, goals_scored, goals_conceded, wins, losses, draws, matches_played)
                VALUES (%s, 0, 0, 0, 0, 0, 0)
            """, (team_name,))

    # 2. Reset team stats
    cur.execute("""
        UPDATE team_stats
        SET goals_scored = 0,
            goals_conceded = 0,
            wins = 0,
            losses = 0,
            draws = 0,
            matches_played = 0
    """)

    # 3. Calculate from match_results
    cur.execute("SELECT home_team, away_team, home_score, away_score, result, winner_team FROM match_results")
    results = cur.fetchall()

    stats = {}
    for (team_name,) in all_teams:
        stats[team_name] = {
            "goals_scored": 0,
            "goals_conceded": 0,
            "wins": 0,
            "losses": 0,
            "draws": 0,
            "matches_played": 0
        }

    for home_team, away_team, home_score, away_score, result, winner_team in results:
        if home_team not in stats:
            stats[home_team] = {"goals_scored": 0, "goals_conceded": 0, "wins": 0, "losses": 0, "draws": 0, "matches_played": 0}
        if away_team not in stats:
            stats[away_team] = {"goals_scored": 0, "goals_conceded": 0, "wins": 0, "losses": 0, "draws": 0, "matches_played": 0}

        stats[home_team]["matches_played"] += 1
        stats[away_team]["matches_played"] += 1

        stats[home_team]["goals_scored"] += home_score
        stats[home_team]["goals_conceded"] += away_score
        stats[away_team]["goals_scored"] += away_score
        stats[away_team]["goals_conceded"] += home_score

        if result == "DRAW":
            stats[home_team]["draws"] += 1
            stats[away_team]["draws"] += 1
        elif result == "WIN_HOME":
            stats[home_team]["wins"] += 1
            stats[away_team]["losses"] += 1
        elif result == "WIN_AWAY":
            stats[away_team]["wins"] += 1
            stats[home_team]["losses"] += 1

    # 4. Update team_stats table
    for team_name, s in stats.items():
        cur.execute("SELECT 1 FROM team_stats WHERE team_name = %s", (team_name,))
        if not cur.fetchone():
            cur.execute("""
                INSERT INTO team_stats (team_name, goals_scored, goals_conceded, wins, losses, draws, matches_played)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (team_name, s["goals_scored"], s["goals_conceded"], s["wins"], s["losses"], s["draws"], s["matches_played"]))
        else:
            cur.execute("""
                UPDATE team_stats
                SET goals_scored = %s,
                    goals_conceded = %s,
                    wins = %s,
                    losses = %s,
                    draws = %s,
                    matches_played = %s
                WHERE team_name = %s
            """, (
                s["goals_scored"],
                s["goals_conceded"],
                s["wins"],
                s["losses"],
                s["draws"],
                s["matches_played"],
                team_name
            ))

    conn.commit()
    cur.close()
    conn.close()
    print("Team stats updated.")
