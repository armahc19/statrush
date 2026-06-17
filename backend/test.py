import time
import requests
import psycopg2
from datetime import datetime
import schedule

API_TOKEN = "c9061779d5d440749f4729ababc35465"
BASE_URL = "https://api.football-data.org/v4"

COMPETITION_ID = 2000

HEADERS = {
    "X-Auth-Token": API_TOKEN
}

DB_CONFIG = {
    "dbname": "statrush",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}


def get_conn():
    return psycopg2.connect(**DB_CONFIG)


def fetch_finished_matches(date_from=None, date_to=None):
    url = f"{BASE_URL}/competitions/{COMPETITION_ID}/matches"

    params = {}

    if date_from:
        params["dateFrom"] = date_from
    if date_to:
        params["dateTo"] = date_to

    res = requests.get(url, headers=HEADERS, params=params)
    res.raise_for_status()

    matches = res.json().get("matches", [])

    finished = []

    for m in matches:
        if m.get("status") != "FINISHED":
            continue

        score = m.get("score", {}).get("fullTime", {})

        finished.append({
            "event_id": m.get("id"),
            "home_team": m["homeTeam"]["name"],
            "away_team": m["awayTeam"]["name"],
            "home_score": score.get("home"),
            "away_score": score.get("away"),
            "winner": m.get("score", {}).get("winner"),
            "date": m.get("utcDate")
        })

    return finished

def upsert_matches(matches):
    conn = get_conn()
    cur = conn.cursor()

    for m in matches:
        event_id = m["event_id"]
        home = m["home_team"]
        away = m["away_team"]
        home_score = m["home_score"]
        away_score = m["away_score"]
        winner = m["winner"]
        result = "FINISHED"

        # 1. check if exists
        cur.execute("""
            SELECT home_team, away_team, home_score, away_score, result, winner_team
            FROM match_results
            WHERE event_id = %s
        """, (event_id,))

        existing = cur.fetchone()

        # 2. IF NOT EXISTS → INSERT
        if not existing:
            cur.execute("""
                INSERT INTO match_results (
                    event_id,
                    home_team,
                    away_team,
                    home_score,
                    away_score,
                    result,
                    winner_team,
                    created_at
                )
                VALUES (%s,%s,%s,%s,%s,%s,%s,NOW())
            """, (
                event_id,
                home,
                away,
                home_score,
                away_score,
                result,
                winner
            ))

            print(f"🆕 INSERTED match {event_id}")
            continue

        # 3. IF EXISTS → CHECK CHANGES
        db_home, db_away, db_hs, db_as, db_result, db_winner = existing

        if (
            db_home == home and
            db_away == away and
            db_hs == home_score and
            db_as == away_score and
            db_result == result and
            db_winner == winner
        ):
            print(f"⏭ SKIPPED (no change) {event_id}")
            continue

        # 4. IF CHANGED → UPDATE
        cur.execute("""
            UPDATE match_results
            SET home_team = %s,
                away_team = %s,
                home_score = %s,
                away_score = %s,
                result = %s,
                winner_team = %s,
                created_at = NOW()
            WHERE event_id = %s
        """, (
            home,
            away,
            home_score,
            away_score,
            result,
            winner,
            event_id
        ))

        print(f"🔄 UPDATED match {event_id}")

    conn.commit()
    cur.close()
    conn.close()

    print(f"✅ Sync completed @ {datetime.now()}")

def sync_matches():
    try:
        print("🔄 Fetching finished matches...")

        matches = fetch_finished_matches(
            date_from="2026-06-11",
            date_to="2026-07-19"
        )

        print(f"📦 {len(matches)} finished matches found")

        upsert_matches(matches)

    except Exception as e:
        print("❌ Sync failed:", e)


def start_scheduler():
    schedule.every(5).hours.do(sync_matches)

    print("🚀 Match sync scheduler running (every 5 hours)")

    while True:
        schedule.run_pending()
        time.sleep(60)


if __name__ == "__main__":
    sync_matches()        # run once immediately
    start_scheduler()     # then run every 5 hours