from normalize import normalize
from db import get_conn


def rebuild_player_stats():
    conn = get_conn()
    cur = conn.cursor()

    # -----------------------------------
    # RESET ALL PLAYER STATS
    # -----------------------------------
    cur.execute("""
        UPDATE players
        SET goals = 0,
            yellow_cards = 0,
            red_cards = 0,
            points = 0
    """)

    # -----------------------------------
    # GET ALL PLAYERS FROM EVENTS
    # -----------------------------------
    cur.execute("""
        SELECT DISTINCT player_name, team_name
        FROM match_events
        WHERE player_name IS NOT NULL
    """)

    players = cur.fetchall()

    # -----------------------------------
    # BUILD STATS FROM EVENTS
    # -----------------------------------
    for player_name, team_name in players:

        # GOALS
        cur.execute("""
            SELECT COUNT(*)
            FROM match_events
            WHERE player_name = %s
            AND event_type = 'GOAL'
        """, (player_name,))
        goals = cur.fetchone()[0]

        # YELLOW CARDS
        cur.execute("""
            SELECT COUNT(*)
            FROM match_events
            WHERE player_name = %s
            AND event_type = 'YELLOW_CARD'
        """, (player_name,))
        yellow = cur.fetchone()[0]

        # RED CARDS
        cur.execute("""
            SELECT COUNT(*)
            FROM match_events
            WHERE player_name = %s
            AND event_type = 'RED_CARD'
        """, (player_name,))
        red = cur.fetchone()[0]

        # POINTS RULE
        points = (goals * 5) - yellow - (red * 3)

        # -----------------------------------
        # UPDATE PLAYER TABLE USING ROBUST RESOLVER
        # -----------------------------------
        norm_name = normalize(player_name)
        norm_name_alt = norm_name.replace(' jr', ' junior') if ' jr' in norm_name else norm_name

        player_id = None

        # 1. Try matching with team_name if team_name is provided
        if team_name:
            cur.execute('SELECT id FROM players WHERE name_norm = %s AND team_name = %s', (norm_name, team_name))
            row = cur.fetchone()
            if not row and norm_name_alt != norm_name:
                cur.execute('SELECT id FROM players WHERE name_norm = %s AND team_name = %s', (norm_name_alt, team_name))
                row = cur.fetchone()
            if not row:
                cur.execute('SELECT id FROM players WHERE name_norm ILIKE %s AND team_name = %s', (f'%{norm_name}%', team_name))
                row = cur.fetchone()
            if not row and norm_name_alt != norm_name:
                cur.execute('SELECT id FROM players WHERE name_norm ILIKE %s AND team_name = %s', (f'%{norm_name_alt}%', team_name))
                row = cur.fetchone()
            if row:
                player_id = row[0]

        # 2. Fallback to matching by name only (if team_name is None or scoped match failed)
        if not player_id:
            cur.execute('SELECT id FROM players WHERE name_norm = %s', (norm_name,))
            row = cur.fetchone()
            if not row and norm_name_alt != norm_name:
                cur.execute('SELECT id FROM players WHERE name_norm = %s', (norm_name_alt,))
                row = cur.fetchone()
            if not row:
                if len(norm_name) > 4:
                    cur.execute('SELECT id FROM players WHERE name_norm ILIKE %s', (f'%{norm_name}%',))
                    row = cur.fetchone()
                    if not row and norm_name_alt != norm_name:
                        cur.execute('SELECT id FROM players WHERE name_norm ILIKE %s', (f'%{norm_name_alt}%',))
                        row = cur.fetchone()
                else:
                    cur.execute('SELECT id FROM players WHERE name_norm ILIKE %s', (f'%{norm_name}',))
                    row = cur.fetchone()
            if row:
                player_id = row[0]

        # 3. Update the resolved player by ID
        if player_id:
            cur.execute("""
                UPDATE players
                SET goals = %s,
                    yellow_cards = %s,
                    red_cards = %s,
                    points = %s
                WHERE id = %s
            """, (
                goals,
                yellow,
                red,
                points,
                player_id
            ))

    conn.commit()
    cur.close()
    conn.close()

    print("Player stats rebuilt in players table.")