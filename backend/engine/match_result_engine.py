from db import get_conn


def compute_and_store_match_result(event):
    conn = get_conn()
    cur = conn.cursor()

    event_id = event["id"]
    home_team = event["home_team"]
    away_team = event["away_team"]

    home_score = event.get("home_score", 0)
    away_score = event.get("away_score", 0)

    # -------------------------
    # DETERMINE RESULT
    # -------------------------
    if home_score > away_score:
        result = "WIN_HOME"
        winner = home_team

    elif away_score > home_score:
        result = "WIN_AWAY"
        winner = away_team

    else:
        result = "DRAW"
        winner = None

    # -------------------------
    # INSERT MATCH RESULT
    # -------------------------
    cur.execute("""
        INSERT INTO match_results (
            event_id,
            home_team,
            away_team,
            home_score,
            away_score,
            result,
            winner_team
        )
        VALUES (%s,%s,%s,%s,%s,%s,%s)
        ON CONFLICT (event_id) DO NOTHING
    """, (
        event_id,
        home_team,
        away_team,
        home_score,
        away_score,
        result,
        winner
    ))

    conn.commit()
    cur.close()
    conn.close()

    return {
        "event_id": event_id,
        "result": result,
        "winner": winner
    }
