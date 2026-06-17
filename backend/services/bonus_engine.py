from db import get_conn


def apply_bonus(result):
    conn = get_conn()
    cur = conn.cursor()

    event_id = result["event_id"]
    winner = result["winner"]

    # -----------------------------------
    # DRAW CASE
    # -----------------------------------
    if winner is None:
        cur.execute("""
            UPDATE players
            SET points = points + 1
        """)

        conn.commit()
        cur.close()
        conn.close()

        print("Draw bonus applied (+1 all players)")
        return

    # -----------------------------------
    # WINNER BONUS
    # -----------------------------------
    cur.execute("""
        UPDATE players
        SET points = points + 3
        WHERE team_name = %s
    """, (winner,))

    conn.commit()
    cur.close()
    conn.close()

    print(f"Win bonus applied to {winner} (+3 players)")
