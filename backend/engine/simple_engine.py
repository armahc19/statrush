"""from loader import get_event, get_incidents

event = get_event("/home/scriptgad/Documents/Projects/StatRush/mock_data/event.json")[0]
incidents = get_incidents("/home/scriptgad/Documents/Projects/StatRush/mock_data/incidents.json")[0]

print(event)
print(incidents)

print("MATCH:")
print(event["home_team"], "vs", event["away_team"])
print(event["home_score"], ":", event["away_score"])

#print("\nINCIDENTS:")
# Fix this line - incidents is a dict with an 'incidents' key
#for incident in incidents["incidents"]:  # Changed from 'for i in incidents:'
#    print(incident)

print("\nINCIDENTS:")
for incident in incidents["incidents"]:
    if incident["type"] == "goal":
        print(f"  ⚽ {incident['minute']}' - {incident['player']} ({incident['team']})")
    elif incident["type"] == "card":
        print(f"  🟨 {incident['minute']}' - {incident['player']} ({incident['card_type']} card)")
    elif incident["type"] == "substitution":
        print(f"  🔄 {incident['minute']}' - {incident['player_out']} OUT, {incident['player_in']} IN")
"""

# In engine/index.py
import sys
import os


sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from db import get_conn

# Import specific functions/variables
from services.player_stats import rebuild_player_stats
from services.bonus_engine import apply_bonus

from match_result_engine import compute_and_store_match_result
from match_guard import match_already_processed



from loader import get_event, get_incidents
from db_writer import insert_event

conn = get_conn()
cur = conn.cursor()

event = get_event("/home/scriptgad/Documents/Projects/StatRush/mock_data/event.json")[0]
incidents = get_incidents("/home/scriptgad/Documents/Projects/StatRush/mock_data/incidents.json")[0]

event_id = event["id"]
home_team = event["home_team"]
away_team = event["away_team"]


# THIS IS THE GUARD (must be BEFORE processing anything)
if match_already_processed(cur, event_id):
    print("Match already processed. Skipping.")
    cur.close()
    conn.close()
    exit()

def process_incident(inc):
    t = inc["type"]

    if t == "goal":
        insert_event(
            event_type="GOAL",
            minute=inc["minute"],
            team_name=inc.get("team"),
            player_name=inc["player"]
        )

    elif t == "card":

        card_type = inc.get("card_type", "").upper()

        insert_event(
            event_type=f"{card_type}_CARD",
            minute=inc["minute"],
            team_name=inc.get("team"),
            player_name=inc["player"]
        )

#for inc in incidents:
#    process_incident(inc)

for inc in incidents["incidents"]:  # ← Notice the ["incidents"] key
    process_incident(inc)


result = compute_and_store_match_result(event)
rebuild_player_stats()
apply_bonus(result)
print("complete")


'''print("MATCH:")
print(event["home_team"], "vs", event["away_team"])
print(event["home_score"], ":", event["away_score"])

print("\nINCIDENTS:")

def process_incident(inc):
    if inc["type"] == "goal":
        print("GOAL:", inc["player"])
    elif inc["type"] == "card":
        print("CARD:", inc["player"], inc.get("card_type"))
    elif inc["type"] == "substitution":
        print("SUB:", inc["player_out"], "->", inc["player_in"])

# Loop through incidents
for inc in incidents["incidents"]:
    process_incident(inc) '''


