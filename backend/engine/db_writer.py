import sys
import os

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from db import get_conn

def insert_event(
    event_type,
    minute,
    team_name,
    player_name
):
    conn = get_conn()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO match_events (
            event_type,
            minute,
            team_name,
            player_name
        )
        VALUES (%s, %s, %s, %s)
    """, (
        event_type,
        minute,
        team_name,
        player_name
    ))

    conn.commit()

    cur.close()
    conn.close()
