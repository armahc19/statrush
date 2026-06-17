import requests

API_TOKEN = "c9061779d5d440749f4729ababc35465"
BASE_URL = "https://api.football-data.org/v4"

headers = {
    "X-Auth-Token": API_TOKEN
}

# Step 1: Get all competitions (to find World Cup ID)
def get_competitions():
    url = f"{BASE_URL}/competitions"
    res = requests.get(url, headers=headers)
    return res.json()

# Step 2: Get matches for a competition on a date
def get_matches(competition_id, date):
    url = f"{BASE_URL}/competitions/{competition_id}/matches"
    
    params = {
        "dateFrom": date,
        "dateTo": date
    }

    res = requests.get(url, headers=headers, params=params)
    return res.json()

# ---------------- MAIN ---------------- #

if __name__ == "__main__":
    print("Fetching competitions...")

    comps = get_competitions()

    world_cup_id = None

    # Try to find World Cup competition
    for comp in comps.get("competitions", []):
        name = comp.get("name", "").lower()
        if "world cup" in name:
            world_cup_id = comp["id"]
            print("Found World Cup ID:", world_cup_id, "-", comp["name"])
            break

    if not world_cup_id:
        print("World Cup competition not found in API.")
        exit()

    print("\nFetching matches for 11 June 2026...\n")

    data = get_matches(world_cup_id, "2026-06-11")

    matches = data.get("matches", [])

    if not matches:
        print("No matches found for that date.")
    else:
        for m in matches:
            home = m["homeTeam"]["name"]
            away = m["awayTeam"]["name"]
            status = m["status"]
            utc = m["utcDate"]

            print(f"{home} vs {away} | {status} | {utc}")