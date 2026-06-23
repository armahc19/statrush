"""
Bing Event Mapper
Calls the Bing scraper and maps raw events to the backend's 4 event types:
- Goal ⚽
- Assist 🎯
- Yellow Card 🟨
- Red Card 🟥
"""

import re
from bs4 import BeautifulSoup
from services import bing_events_extract  # your existing script as a module


# Map scraper types to backend event types
EVENT_TYPE_MAP = {
    "goal": "Goal ⚽",
    "own_goal": "Goal ⚽",
    "penalty_goal": "Goal ⚽",
    "yellow_card": "Yellow Card 🟨",
    "red_card": "Red Card 🟥",
    # These are ignored (returned as skipped)
    "assist": "Assist 🎯",
    "penalty_missed": None,
    "substitution": None,
    "half_time": None,
    "full_time": None,
    "kick_off": None,
    "set_piece": None,
    "var_check": None,
    "injury": None,
    "penalty": None,
    "other": None,
}


def assign_team(raw_text: str, home_team: str, away_team: str) -> str | None:
    """
    Determine which team an event belongs to by checking which team name
    appears in the raw event text.
    """
    text_lower = raw_text.lower()
    home_lower = home_team.lower()
    away_lower = away_team.lower()

    home_mentioned = home_lower in text_lower
    away_mentioned = away_lower in text_lower

    if home_mentioned and not away_mentioned:
        return home_team
    elif away_mentioned and not home_mentioned:
        return away_team
    elif home_mentioned and away_mentioned:
        # Both mentioned - check which appears first
        home_pos = text_lower.find(home_lower)
        away_pos = text_lower.find(away_lower)
        return home_team if home_pos < away_pos else away_team

    # Neither team mentioned - return None for manual review
    return None


def parse_minute_to_int(minute_str: str) -> int:
    """
    Convert minute strings like '45+2', '90', '120' to integer.
    For stoppage time like '45+2', returns the base minute (45).
    """
    if not minute_str:
        return 0

    # Handle '45+2' format
    match = re.match(r"(\d+)(?:\+(\d+))?", str(minute_str))
    if match:
        return int(match.group(1))

    # Fallback - try direct conversion
    try:
        return int(minute_str)
    except (ValueError, TypeError):
        return 0


def extract_team_from_event(raw_text: str, player_name: str, home_team: str, away_team: str) -> str | None:
    """
    Try multiple strategies to determine which team an event belongs to.
    """
    # Strategy 1: Direct team name mention in text
    team = assign_team(raw_text, home_team, away_team)
    if team:
        return team

    # Strategy 2: Check if player name appears near team name
    # This is a simplified approach - in production you'd use a player database
    text_lower = raw_text.lower()

    # Look for patterns like "Player (Team)" or "Player of Team"
    paren_match = re.search(rf"{re.escape(player_name)}\s*\(({re.escape(home_team)}|{re.escape(away_team)})\)", raw_text, re.IGNORECASE)
    if paren_match:
        return paren_match.group(1)

    # Strategy 3: Check if the player is mentioned in context of scoring/conceding
    # If neither works, default to home team with a flag
    return None  # Will be handled by the caller (defaults to home team with warning)


def scrape_and_map(url: str, home_team: str, away_team: str) -> dict:
    """
    Main entry point for the API.

    Args:
        url: Full Bing SportsDetails URL
        home_team: Name of the home team
        away_team: Name of the away team

    Returns:
        dict with:
            - status: 'success' or 'error'
            - events: list of mapped events ready for the frontend
            - skipped: list of skipped raw events
            - total_found: total events found on Bing
            - total_mapped: events successfully mapped to the 4 types
    """
    # 1. Fetch and parse the Bing page
    html = bing_events_extract.fetch_page(url)
    soup = BeautifulSoup(html, "html.parser")

    # 2. Extract raw events using the existing scraper
    raw_events = bing_events_extract.parse_events(soup)

    # 3. Map and filter
    mapped_events = []
    skipped_events = []

    for raw_event in raw_events:
        scraper_type = raw_event.get("type", "other")
        backend_type = EVENT_TYPE_MAP.get(scraper_type)

        if backend_type is None:
            # Event type we don't support
            skipped_events.append({
                "raw": raw_event.get("raw", ""),
                "type": scraper_type,
                "minute": raw_event.get("minute"),
                "reason": f"Unsupported event type: {scraper_type}"
            })
            continue

        # Extract minute as integer
        minute_str = raw_event.get("minute", "0")
        minute_int = parse_minute_to_int(minute_str)

        # Extract player name
        player = raw_event.get("player", "").strip()
        if not player:
            # Try harder to extract player from raw text
            players = bing_events_extract.extract_players(raw_event.get("raw", ""))
            player = players.get("primary", "Unknown")

        # Assign team
        raw_text = raw_event.get("raw", "")
        team = extract_team_from_event(raw_text, player, home_team, away_team)

        mapped_events.append({
            "player": player or "Unknown",
            "type": backend_type,
            "team": team or home_team,  # Default to home team if unassigned
            "team_confirmed": team is not None,  # Flag for frontend review
            "minute": minute_int,
            "minute_display": f"{minute_str}'",
            "raw_text": raw_text,
        })

    # Sort by minute
    mapped_events.sort(key=lambda e: e["minute"])

    return {
        "status": "success",
        "events": mapped_events,
        "skipped": skipped_events,
        "total_found": len(raw_events),
        "total_mapped": len(mapped_events),
    }