#!/usr/bin/env python3
"""
Sportmonks API - Match Events Fetcher
Mexico vs South Africa - World Cup 2026 (June 11, 2026)
"""

import requests
from datetime import datetime
from typing import Dict, List, Optional, Any

# Your API Token
API_TOKEN = "MnSxqTByplMYpuZnUnXmvkKIFNuafwcELcEbRnjepneQ7JmY4fHZhlXi5RkD"
BASE_URL = "https://api.sportmonks.com/v3/football"

# Match details
TARGET_DATE = "2026-06-11"
HOME_TEAM = "Mexico"
AWAY_TEAM = "South Africa"


def make_request(endpoint: str, params: Dict = None) -> Optional[Dict]:
    """Make authenticated request to Sportmonks API."""
    if params is None:
        params = {}
    params["api_token"] = API_TOKEN
    
    url = f"{BASE_URL}/{endpoint}"
    
    try:
        response = requests.get(url, params=params, timeout=30)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"  ✗ API Error: {e}")
        if hasattr(e, 'response') and e.response:
            print(f"    Response: {e.response.text[:200]}")
        return None


def find_team_id(team_name: str) -> Optional[int]:
    """Find team ID by searching for team name."""
    print(f"  🔍 Searching for team: {team_name}")
    
    # Search for team
    response = make_request(f"teams/search/{team_name}")
    
    if response and response.get("data"):
        for team in response["data"]:
            if team.get("name", "").lower() == team_name.lower():
                team_id = team.get("id")
                print(f"    ✓ Found {team_name} (ID: {team_id})")
                return team_id
    
    print(f"    ✗ Could not find {team_name}")
    return None


def find_fixture(team1_id: int, team2_id: int, date: str) -> Optional[Dict]:
    """Find fixture between two teams on specific date."""
    print(f"  🔍 Searching for fixture on {date}...")
    
    # Try multiple approaches to find the fixture
    
    # Approach 1: Search by date range for each team
    for team_id in [team1_id, team2_id]:
        endpoint = f"fixtures/between/{date}/{date}/{team_id}"
        response = make_request(endpoint, {"include": "participants"})
        
        if response and response.get("data"):
            for fixture in response["data"]:
                participants = fixture.get("participants", {}).get("data", [])
                team_names = [p.get("name", "") for p in participants]
                
                if (HOME_TEAM in team_names and AWAY_TEAM in team_names):
                    print(f"    ✓ Found fixture ID: {fixture['id']}")
                    return fixture
    
    # Approach 2: Search by date range general
    endpoint = f"fixtures/between/{date}/{date}"
    response = make_request(endpoint, {"include": "participants"})
    
    if response and response.get("data"):
        for fixture in response["data"]:
            participants = fixture.get("participants", {}).get("data", [])
            team_names = [p.get("name", "") for p in participants]
            
            if (HOME_TEAM in team_names and AWAY_TEAM in team_names):
                print(f"    ✓ Found fixture ID: {fixture['id']}")
                return fixture
    
    print(f"    ⚠️ Fixture not found (match may not be scheduled in API yet)")
    return None


def fetch_match_events(fixture_id: int) -> Dict:
    """Fetch all match events for a fixture."""
    print(f"  📊 Fetching match events for fixture {fixture_id}...")
    
    # Include all relevant data: events, scores, participants, lineups
    endpoint = f"fixtures/{fixture_id}"
    response = make_request(
        endpoint,
        {"include": "events;participants;scores;lineups;state"}
    )
    
    if not response or not response.get("data"):
        print(f"    ✗ No data returned")
        return {}
    
    fixture = response["data"]
    
    # Extract events
    events_data = fixture.get("events", {}).get("data", [])
    
    # Event type mapping (common type_ids)
    # type_id 14 = Goal, 15 = Own Goal, 16 = Penalty Goal
    # type_id 17 = Yellow Card, 18 = Red Card
    # type_id 20 = Substitution, 21 = Substitution (Half)
    event_types = {
        14: "goal",
        15: "own_goal", 
        16: "penalty_goal",
        17: "yellow_card",
        18: "red_card",
        20: "substitution",
        21: "substitution",
    }
    
    events = {
        "goals": [],
        "cards": [],
        "substitutions": [],
        "match_info": {}
    }
    
    # Parse match info
    if fixture.get("starting_at"):
        events["match_info"]["kickoff"] = fixture["starting_at"]
    
    # Parse scores
    scores = fixture.get("scores", {}).get("data", [])
    for score in scores:
        score_type = score.get("description", "")
        home = score.get("score", {}).get("home")
        away = score.get("score", {}).get("away")
        if score_type == "FULLTIME" and home is not None:
            events["match_info"]["score"] = f"{home} - {away}"
    
    # Parse venue
    venue = fixture.get("venue", {}).get("data", {})
    if venue:
        events["match_info"]["venue"] = venue.get("name", "")
        events["match_info"]["city"] = venue.get("city", "")
    
    # Parse match state
    state = fixture.get("state", {}).get("data", {})
    if state:
        events["match_info"]["status"] = state.get("name", "Unknown")
        events["match_info"]["state_id"] = state.get("id")
    
    # Parse events
    for event in events_data:
        event_type_id = event.get("type_id")
        event_type = event_types.get(event_type_id, "unknown")
        
        minute = event.get("minute")
        extra_minute = event.get("extra_minute")
        
        # Format time display
        if extra_minute:
            time_display = f"{minute}+{extra_minute}'"
        else:
            time_display = f"{minute}'" if minute else "?"
        
        player = event.get("player", {}).get("data", {}).get("name") if event.get("player") else None
        player_name = player or event.get("player_name") or "Unknown"
        
        team = event.get("team", {}).get("data", {}).get("name") if event.get("team") else None
        
        if event_type in ["goal", "own_goal", "penalty_goal"]:
            assist = None
            assist_player = event.get("assist", {}).get("data", {}).get("name") if event.get("assist") else None
            if assist_player:
                assist = assist_player
            
            events["goals"].append({
                "minute": minute,
                "minute_display": time_display,
                "scorer": player_name,
                "assist": assist,
                "team": team
            })
        
        elif event_type in ["yellow_card", "red_card"]:
            card_type = "yellow" if event_type == "yellow_card" else "red"
            events["cards"].append({
                "minute": minute,
                "minute_display": time_display,
                "player": player_name,
                "type": card_type,
                "team": team
            })
        
        elif event_type == "substitution":
            player_out = player_name
            player_in = None
            substitute = event.get("substitute", {}).get("data", {})
            if substitute:
                player_in = substitute.get("name")
            
            events["substitutions"].append({
                "minute": minute,
                "minute_display": time_display,
                "out": player_out,
                "in": player_in or "Unknown",
                "team": team
            })
    
    print(f"    ✓ Found {len(events['goals'])} goals, {len(events['cards'])} cards, {len(events['substitutions'])} subs")
    return events


def display_match_events(events: Dict) -> None:
    """Display match events in a clean format."""
    print("\n" + "=" * 65)
    print("  MEXICO vs SOUTH AFRICA — WORLD CUP 2026")
    print("=" * 65)
    
    # Match Info
    info = events.get("match_info", {})
    if info.get("score"):
        print(f"\n  📊 FINAL SCORE:      {info['score']}")
    if info.get("kickoff"):
        kickoff = datetime.fromisoformat(info["kickoff"].replace(" ", "T"))
        print(f"  📅 KICKOFF:          {kickoff.strftime('%Y-%m-%d %H:%M UTC')}")
    if info.get("venue"):
        venue_text = info['venue']
        if info.get("city"):
            venue_text += f", {info['city']}"
        print(f"  🏟️ VENUE:            {venue_text}")
    if info.get("status"):
        print(f"  📌 MATCH STATUS:     {info['status']}")
    
    # Goals
    goals = events.get("goals", [])
    if goals:
        print(f"\n  ⚽ GOALS ({len(goals)}):")
        for goal in goals:
            time_str = goal.get("minute_display", "?")
            scorer = goal.get("scorer", "Unknown")
            assist = goal.get("assist")
            assist_text = f" (assist: {assist})" if assist else ""
            team = goal.get("team", "")
            team_prefix = f"[{team}] " if team else ""
            print(f"    • {team_prefix}{scorer} {time_str}{assist_text}")
    else:
        print("\n  ⚽ No goal data available")
    
    # Cards
    cards = events.get("cards", [])
    if cards:
        print(f"\n  🟨🟥 BOOKINGS ({len(cards)}):")
        for card in cards:
            time_str = card.get("minute_display", "?")
            player = card.get("player", "Unknown")
            card_type = card.get("type", "unknown")
            symbol = "🟥" if card_type == "red" else "🟨"
            team = card.get("team", "")
            team_prefix = f"[{team}] " if team else ""
            print(f"    {symbol} {team_prefix}{player} {time_str}")
    
    # Substitutions
    subs = events.get("substitutions", [])
    if subs:
        print(f"\n  🔄 SUBSTITUTIONS ({len(subs)}):")
        for sub in subs:
            time_str = sub.get("minute_display", "?")
            out_player = sub.get("out", "?")
            in_player = sub.get("in", "?")
            team = sub.get("team", "")
            team_prefix = f"[{team}] " if team else ""
            print(f"    • {team_prefix}{out_player} → {in_player} ({time_str})")
    
    print("\n" + "=" * 65)
    print(f"  Data Source: Sportmonks API v3")
    print(f"  Timestamp:   {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}")
    print("=" * 65)


def main():
    print("\n" + "=" * 65)
    print("  🌍 SPORTMONKS API - MATCH EVENTS FETCHER")
    print(f"  Mexico vs South Africa - World Cup 2026")
    print(f"  Date: {TARGET_DATE}")
    print("=" * 65 + "\n")
    
    # Step 1: Find team IDs
    mexico_id = find_team_id(HOME_TEAM)
    south_africa_id = find_team_id(AWAY_TEAM)
    
    if not mexico_id or not south_africa_id:
        print("\n  ❌ Could not find team IDs. Exiting.")
        print("\n  Note: The 2026 World Cup fixtures may not be populated in")
        print("        the Sportmonks API yet. This script will work when")
        print("        the tournament data becomes available.")
        return
    
    # Step 2: Find the fixture
    fixture = find_fixture(mexico_id, south_africa_id, TARGET_DATE)
    
    if not fixture:
        print("\n  ⚠️ Fixture not found in Sportmonks database.")
        print("\n  Possible reasons:")
        print("    1. The 2026 World Cup schedule isn't loaded yet")
        print("    2. The fixture IDs need to be looked up manually first")
        print("    3. Your API plan may have league restrictions")
        print("\n  Alternative: Use the 'Get All Fixtures' endpoint to browse")
        print("              available matches.")
        return
    
    # Step 3: Fetch match events
    fixture_id = fixture["id"]
    events = fetch_match_events(fixture_id)
    
    # Step 4: Display results
    if events.get("goals") or events.get("cards"):
        display_match_events(events)
    else:
        print("\n  ⚠️ No event data available for this fixture.")
        print("\n  Note: Match events (goals, cards) are only available")
        print("        AFTER the match has been played. Since this is")
        print("        a future match (June 2026), no event data exists yet.")
        print("\n  The fixture exists, but you'll need to wait until")
        print("  after the match date to fetch the actual events.")


if __name__ == "__main__":
    main()