#!/usr/bin/env python3
"""
Bing Sports Match Events Scraper
Extracts live match events from Bing's SportsDetails page.
"""

import requests
import re
import json
import sys
from urllib.parse import urlencode, quote
from bs4 import BeautifulSoup, Tag


HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
}


def build_url(
    team1: str,
    team2: str,
    game_id: str,
    league: str = "Soccer_InternationalWorldCup",
    season: int = 2026,
    venue_id: str = "",
    timezone: str = "Greenwich Standard Time",
    iana_tz: str = "Africa/Accra",
    iso_key: str = "GMT",
) -> str:
    """Build a Bing SportsDetails URL from match parameters."""
    params = {
        "q": f"{team1} vs {team2}",
        "gameid": game_id,
        "league": league,
        "scenario": "GameCenter",
        "intent": "Game",
        "iscelebratedgame": True,
        "sport": "Soccer",
        "TimezoneId": timezone,
        "IANATimezoneId": iana_tz,
        "ISOTimezoneKey": iso_key,
        "seasonyear": season,
        "form": "ARENL1",
        "segment": "sports",
        "isl2": "true",
    }
    if venue_id:
        params["venueid"] = json.dumps({"id": venue_id})

    return "https://www.bing.com/sportsdetails?" + urlencode(params, doseq=True)


def fetch_page(url: str) -> str:
    """Fetch the Bing sports details HTML page."""
    resp = requests.get(url, headers=HEADERS, timeout=15)
    resp.raise_for_status()
    return resp.text


def parse_match_meta(soup: BeautifulSoup) -> dict:
    """Extract match-level metadata from the page."""
    meta = {}

    # Try to find the scoreline
    score_el = soup.select_one("[class*='score']")
    if score_el:
        meta["score"] = score_el.get_text(strip=True)

    # Try to find team names from headings
    for el in soup.select("h1, h2, h3, [class*='team'], [class*='Team']"):
        text = el.get_text(strip=True)
        if text and "vs" in text.lower():
            meta["matchup"] = text
            break

    # Try to find match status
    status_el = soup.select_one("[class*='status'], [class*='Status']")
    if status_el:
        meta["status"] = status_el.get_text(strip=True)

    # Try finding score from the page title or description
    desc = soup.select_one("meta[name='description']")
    if desc and desc.get("content"):
        meta["description"] = desc["content"]

    return meta


def extract_minute(element: Tag) -> str | None:
    """Extract minute from various possible locations in the element."""
    # Check data attributes first
    minute = element.get("data-minute") or element.get("data-time") or element.get("data-event-minute")
    if minute:
        return minute

    # Look for dedicated minute/clock elements (common in Bing's structure)
    clock_el = element.select_one("[class*='clock'], [class*='minute'], [class*='time'], [class*='Clock'], [class*='Minute'], [class*='Time']")
    if clock_el:
        text = clock_el.get_text(strip=True)
        # Try to extract numeric minute
        num_match = re.search(r"(\d+)(?:\s*\+\s*(\d+))?", text)
        if num_match:
            base = num_match.group(1)
            extra = num_match.group(2)
            return f"{base}+{extra}" if extra else base
        return text

    # Try to find minute in text (e.g., "66'")
    text = element.get_text(strip=True)
    minute_match = re.search(r"(\d+)\s*['′]\s*(\+\s*(\d+)\s*['′])?", text)
    if minute_match:
        base = minute_match.group(1)
        extra = minute_match.group(3)  # group 2 includes the +, group 3 is just the number
        return f"{base}+{extra}" if extra else base

    return None


def classify_event_type(text: str) -> str:
    """Classify event type based on text content."""
    lower = text.lower()
    
    # Check for goal
    if any(kw in lower for kw in ["goal", "scores", "scored", "strikes", "heads home", "finishes"]):
        return "goal"
    # Check for own goal
    if "own goal" in lower:
        return "own_goal"
    # Check for penalty
    if "penalty" in lower:
        if any(kw in lower for kw in ["scored", "goal", "converts"]):
            return "penalty_goal"
        elif "missed" in lower or "saved" in lower:
            return "penalty_missed"
        return "penalty"
    # Check for cards
    if "red card" in lower or "sent off" in lower:
        return "red_card"
    if any(kw in lower for kw in ["yellow card", "booking", "cautioned"]):
        return "yellow_card"
    # Check for substitutions
    if any(kw in lower for kw in ["substitution", "replaces", "comes on", "on for", "off for"]):
        return "substitution"
    # Check for match periods
    if any(kw in lower for kw in ["half time", "halftime", "half-time"]):
        return "half_time"
    if any(kw in lower for kw in ["full time", "fulltime", "full-time", "match ends"]):
        return "full_time"
    if any(kw in lower for kw in ["kick off", "kickoff", "underway"]):
        return "kick_off"
    # Check for set pieces/other
    if any(kw in lower for kw in ["foul", "free kick", "corner", "offside", "throw"]):
        return "set_piece"
    if "var" in lower:
        return "var_check"
    if "injury" in lower:
        return "injury"
    
    return "other"


def extract_players(text: str) -> dict:
    """Try to extract player names from event text."""
    players = {"primary": "", "secondary": ""}
    
    # Common patterns like "Player Name (Team)" or "Player Name scores"
    name_patterns = [
        r'([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)\s*(?:\([^)]+\))?\s*(?:scores|goal|heads|strikes)',
        r'([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)\s*\(([^)]+)\)',
    ]
    
    for pattern in name_patterns:
        matches = re.findall(pattern, text)
        if matches:
            if isinstance(matches[0], tuple):
                players["primary"] = matches[0][0].strip()
            else:
                players["primary"] = matches[0].strip()
            break
    
    return players


def parse_events(soup: BeautifulSoup) -> list[dict]:
    """
    Parse match events from the Bing SportsDetails page.
    Uses a more targeted approach to avoid duplication.
    """
    events = []
    seen_fingerprints = set()  # To prevent duplicates
    
    # Strategy: Look for the main commentary/timeline container
    # Bing typically has a primary container for the event timeline
    timeline_selectors = [
        "[class*='br-rctimeline']",
        "[class*='matchTimeline']",
        "[class*='commentary']",
        "[class*='events-container']",
        "[class*='match-events']",
        "[data-testid='timeline']",
    ]
    
    # Find the main timeline container (usually the largest or first one)
    timeline_container = None
    for selector in timeline_selectors:
        containers = soup.select(selector)
        if containers:
            # Take the first container found (usually the main one)
            timeline_container = containers[0]
            break
    
    # If no specific container found, try to find any element with multiple event-like children
    if not timeline_container:
        potential_containers = []
        for el in soup.find_all(["div", "ul", "ol"]):
            children = el.find_all(["li", "div", "article"], recursive=False)
            if len(children) >= 3:  # At least 3 children that could be events
                potential_containers.append((el, len(children)))
        
        if potential_containers:
            # Choose the container with the most children (likely the main timeline)
            timeline_container = max(potential_containers, key=lambda x: x[1])[0]
    
    # Extract events from the container
    if timeline_container:
        event_elements = timeline_container.find_all(
            ["div", "li", "article"], 
            recursive=False  # Only direct children to avoid nested duplication
        )
        
        # If no direct children, try deeper
        if not event_elements:
            event_elements = timeline_container.select(
                "[class*='event-item'], [class*='timeline-item'], [class*='row']"
            )
        
        for element in event_elements:
            text = element.get_text(strip=True, separator=" ")
            if not text or len(text) < 5:
                continue
            
            # Create a fingerprint to avoid duplicates
            fingerprint = text[:100]  # First 100 chars as fingerprint
            if fingerprint in seen_fingerprints:
                continue
            seen_fingerprints.add(fingerprint)
            
            ev = {"raw": text}
            
            # Extract minute
            minute = extract_minute(element)
            if minute:
                ev["minute"] = minute
                ev["minute_display"] = f"{minute}'"
            
            # Classify event type
            ev["type"] = classify_event_type(text)
            
            # Try to extract players
            players = extract_players(text)
            if players["primary"]:
                ev["player"] = players["primary"]
            
            events.append(ev)
    
    # Fallback: If still no events, scan for any event-like structures
    if not events:
        # Look for elements with clock/minute indicators
        for el in soup.select("[class*='clock'], [class*='minute'], [class*='time']"):
            parent = el.parent
            if parent:
                text = parent.get_text(strip=True, separator=" ")
                if len(text) > 10:
                    fingerprint = text[:100]
                    if fingerprint not in seen_fingerprints:
                        seen_fingerprints.add(fingerprint)
                        
                        ev = {"raw": text}
                        minute = extract_minute(parent)
                        if minute:
                            ev["minute"] = minute
                            ev["minute_display"] = f"{minute}'"
                        ev["type"] = classify_event_type(text)
                        events.append(ev)
    
    return events


def print_events(events: list[dict], detailed: bool = False):
    """Pretty-print extracted events."""
    if not events:
        print("[!] No events found on the page.")
        print("    The page structure may have changed, or the match may not have started yet.")
        return

    print(f"\n{'='*70}")
    print(f"  MATCH EVENTS — {len(events)} event(s) found")
    print(f"{'='*70}\n")

    for i, ev in enumerate(events, 1):
        minute = ev.get("minute_display", ev.get("minute", "???"))
        ev_type = ev.get("type", "unknown").replace("_", " ").title()
        raw = ev.get("raw", "")
        player = ev.get("player", "")

        if detailed:
            line = f"  [{minute:>6}] {ev_type:<14}"
            if player:
                line += f" | Player: {player}"
            line += f" | {raw}"
            print(line)
        else:
            line = f"  [{minute:>6}] {raw}"
            if player and detailed:
                line += f" ({player})"
            print(line)
        print()


def scrape_by_game_id(
    game_id: str = "",
    team1: str = "",
    team2: str = "",
    url: str = None,
    detailed: bool = False,
) -> list[dict]:
    """
    Main entry point. Either pass a full `url` or provide `game_id` + team names.

    Example game IDs (2026 World Cup):
      France vs Senegal:  SportRadar_Soccer_InternationalWorldCup_2026_Game_66457010
    """
    if url:
        target_url = url
    else:
        if not team1 or not team2:
            raise ValueError("Must provide either `url` or both `team1` and `team2`")
        target_url = build_url(team1, team2, game_id)

    print(f"[+] Fetching: {target_url}")
    html = fetch_page(target_url)
    soup = BeautifulSoup(html, "html.parser")

    meta = parse_match_meta(soup)
    if meta:
        print(f"\n  Matchup:  {meta.get('matchup', 'N/A')}")
        print(f"  Score:    {meta.get('score', 'N/A')}")
        print(f"  Status:   {meta.get('status', 'N/A')}")
        if "description" in meta:
            print(f"  Summary:  {meta['description']}")

    events = parse_events(soup)
    print_events(events, detailed=detailed)
    return events


# ---------------------------------------------------------------------------
#  EXAMPLES
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    # Example with your URL
    events = scrape_by_game_id(
        url="https://www.bing.com/sportsdetails?q=France%20vs%20Iraq&gameid=SportRadar_Soccer_InternationalWorldCup_2026_Game_66457010&league=Soccer_InternationalWorldCup&scenario=GameCenter&intent=Game&iscelebratedgame=True&sport=Soccer&TimezoneId=Greenwich%20Standard%20Time&IANATimezoneId=Africa/Accra&ISOTimezoneKey=GMT&seasonyear=2026&team=SportRadar_Soccer_InternationalWorldCup_2026_Team_4481&team2=SportRadar_Soccer_InternationalWorldCup_2026_Team_4767&venueid={%22id%22:%22SportRadar_Soccer_InternationalWorldCup_2026_Venue_1833%22}:version-1&segment=sports&isl2=true&form=ARENL1&.",
        detailed=True,
    )

    # Export to JSON
    if events:
        with open("match_events.json", "w") as f:
            json.dump(events, f, indent=2, ensure_ascii=False)
        print(f"\n[+] Events also saved to match_events.json")
