from db import get_conn
import unicodedata
import re


def normalize(name):
    if not name:
        return None

    name = name.lower().strip()

    # remove accents (Ordoñez → ordonez)
    name = unicodedata.normalize('NFKD', name)
    name = ''.join(c for c in name if not unicodedata.combining(c))

    # remove symbols (Mbappé → mbappe)
    name = re.sub(r'[^a-z0-9\s]', '', name)

    # clean extra spaces
    name = re.sub(r'\s+', ' ', name).strip()

    return name


def normalize_players():
    conn = get_conn()
    cur = conn.cursor()

    # fetch all players
    cur.execute("SELECT id, name FROM players")
    rows = cur.fetchall()

    updated = 0

    for player_id, name in rows:
        norm = normalize(name)

        cur.execute("""
            UPDATE players
            SET name_norm = %s
            WHERE id = %s
        """, (norm, player_id))

        updated += 1

    conn.commit()
    cur.close()
    conn.close()

    print(f"Normalized {updated} players successfully.")


if __name__ == "__main__":
    normalize_players()