def update_player_stats(cur, event):
    """Update player stats based on event type"""
    player_name = event.get('player')
    team_name = event.get('team')
    event_type = event.get('type')
    
    if not player_name or not team_name:
        return
    
    # Check if player exists
    cur.execute("""
        SELECT id, goals, assists, yellow_cards, red_cards, points 
        FROM players 
        WHERE name = %s AND team_name = %s
    """, (player_name, team_name))
    
    player = cur.fetchone()
    
    if not player:
        # Player doesn't exist - create them with default values
        cur.execute("""
            INSERT INTO players (name, team_name, position, goals, assists, yellow_cards, red_cards, points)
            VALUES (%s, %s, 'MF', 0, 0, 0, 0, 0)
        """, (player_name, team_name))
        
        # Get the newly created player
        cur.execute("""
            SELECT id, goals, assists, yellow_cards, red_cards, points 
            FROM players 
            WHERE name = %s AND team_name = %s
        """, (player_name, team_name))
        player = cur.fetchone()
    
    player_id = player[0]
    current_goals = player[1] or 0
    current_assists = player[2] or 0
    current_yellow = player[3] or 0
    current_red = player[4] or 0
    current_points = player[5] or 0
    
    # Update based on event type
    if "Goal" in event_type:
        new_goals = current_goals + 1
        new_points = current_points + 4  # 4 points per goal
        cur.execute("""
            UPDATE players 
            SET goals = %s, points = %s, updated_at = NOW()
            WHERE id = %s
        """, (new_goals, new_points, player_id))
        
    elif "Assist" in event_type:
        new_assists = current_assists + 1
        new_points = current_points + 3  # 3 points per assist
        cur.execute("""
            UPDATE players 
            SET assists = %s, points = %s, updated_at = NOW()
            WHERE id = %s
        """, (new_assists, new_points, player_id))
        
    elif "Yellow Card" in event_type:
        new_yellow = current_yellow + 1
        new_points = current_points - 1  # -1 point for yellow card
        cur.execute("""
            UPDATE players 
            SET yellow_cards = %s, points = %s, updated_at = NOW()
            WHERE id = %s
        """, (new_yellow, new_points, player_id))
        
    elif "Red Card" in event_type:
        new_red = current_red + 1
        new_points = current_points - 3  # -3 points for red card
        cur.execute("""
            UPDATE players 
            SET red_cards = %s, points = %s, updated_at = NOW()
            WHERE id = %s
        """, (new_red, new_points, player_id))

def calculate_match_result(events, home_team, away_team):
    """Calculate match result from events"""
    # Count goals for each team
    home_goals = 0
    away_goals = 0
    
    for event in events:
        event_type = event.get('type')
        team_name = event.get('team')
        
        # Only count goal events
        if "Goal" in event_type:
            if team_name == home_team:
                home_goals += 1
            elif team_name == away_team:
                away_goals += 1
    
    # Determine result
    if home_goals > away_goals:
        result = "HOME_WIN"
        winner = home_team
    elif away_goals > home_goals:
        result = "AWAY_WIN"
        winner = away_team
    else:
        result = "DRAW"
        winner = None
    
    return {
        "home_score": home_goals,
        "away_score": away_goals,
        "result": result,
        "winner": winner
    }

def update_match_results(cur, match_id, home_team, away_team, home_score, away_score, result, winner):
    """Update or insert match results"""
    # Check if match_results already exists for this fixture
    cur.execute("SELECT id FROM match_results WHERE event_id = %s", (match_id,))
    existing = cur.fetchone()
    
    if existing:
        # Update existing match result
        cur.execute("""
            UPDATE match_results 
            SET 
                home_team = %s,
                away_team = %s,
                home_score = %s,
                away_score = %s,
                result = %s,
                winner_team = %s,
                updated_at = NOW()
            WHERE event_id = %s
        """, (home_team, away_team, home_score, away_score, result, winner, match_id))
    else:
        # Insert new match result
        cur.execute("""
            INSERT INTO match_results 
            (event_id, home_team, away_team, home_score, away_score, result, winner_team, created_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, NOW())
        """, (match_id, home_team, away_team, home_score, away_score, result, winner))


def update_team_stats(cur, team_name, goals_scored, goals_conceded, result_type):
    """Update team statistics based on match result"""
    # Check if team_stats exists for this team
    cur.execute("SELECT id FROM team_stats WHERE team_name = %s", (team_name,))
    existing = cur.fetchone()
    
    if not existing:
        # Create team stats if doesn't exist
        cur.execute("""
            INSERT INTO team_stats 
            (team_name, goals_scored, goals_conceded, wins, losses, draws, matches_played, points, created_at,updated_at)
            VALUES (%s, 0, 0, 0, 0, 0, 0, 0, NOW(),NOW())
        """, (team_name,))
    
    # Update based on result type
    if result_type == "WIN":
        cur.execute("""
            UPDATE team_stats 
            SET 
                goals_scored = goals_scored + %s,
                goals_conceded = goals_conceded + %s,
                wins = wins + 1,
                matches_played = matches_played + 1,
                points = points + 3,
                updated_at = NOW()
            WHERE team_name = %s
        """, (goals_scored, goals_conceded, team_name))
        
    elif result_type == "LOSS":
        cur.execute("""
            UPDATE team_stats 
            SET 
                goals_scored = goals_scored + %s,
                goals_conceded = goals_conceded + %s,
                losses = losses + 1,
                matches_played = matches_played + 1,
                updated_at = NOW()
            WHERE team_name = %s
        """, (goals_scored, goals_conceded, team_name))
        
    elif result_type == "DRAW":
        cur.execute("""
            UPDATE team_stats 
            SET 
                goals_scored = goals_scored + %s,
                goals_conceded = goals_conceded + %s,
                draws = draws + 1,
                matches_played = matches_played + 1,
                points = points + 1,
                updated_at = NOW()
            WHERE team_name = %s
        """, (goals_scored, goals_conceded, team_name))

def update_fixture_status(cur, match_id, status):
    """Update fixture status"""
    cur.execute("""
        UPDATE fixtures 
        SET 
            status = %s

        WHERE id = %s
    """, (status, match_id))

def recalculate_rankings(cur):
    """Recalculate player and team rankings"""
    # Update player rankings
    cur.execute("""
        INSERT INTO player_rankings (player_id, rank, points, goals, assists, updated_at)
        SELECT 
            id,
            RANK() OVER (ORDER BY points DESC, goals DESC, assists DESC) as rank,
            points,
            goals,
            assists,
            NOW()
        FROM players
        WHERE points > 0 OR goals > 0 OR assists > 0
        ON CONFLICT (player_id) 
        DO UPDATE SET 
            rank = EXCLUDED.rank,
            points = EXCLUDED.points,
            goals = EXCLUDED.goals,
            assists = EXCLUDED.assists,
            updated_at = EXCLUDED.updated_at
    """)
    
    # Update team rankings
    cur.execute("""
        INSERT INTO team_rankings (team_id, rank, points, goal_difference, updated_at)
        SELECT 
            ts.id,
            RANK() OVER (ORDER BY ts.points DESC, (ts.goals_scored - ts.goals_conceded) DESC, ts.goals_scored DESC) as rank,
            ts.points,
            (ts.goals_scored - ts.goals_conceded) as goal_difference,
            NOW()
        FROM team_stats ts
        WHERE ts.matches_played > 0
        ON CONFLICT (team_id) 
        DO UPDATE SET 
            rank = EXCLUDED.rank,
            points = EXCLUDED.points,
            goal_difference = EXCLUDED.goal_difference,
            updated_at = EXCLUDED.updated_at
    """)