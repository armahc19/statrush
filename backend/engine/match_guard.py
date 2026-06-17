def match_already_processed(cur, event_id):
    cur.execute("""
        SELECT 1 FROM match_results WHERE event_id = %s
    """, (event_id,))
    return cur.fetchone() is not None
