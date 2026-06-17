import requests

API_BASE_URL = "https://sports.bzzoiro.com/api/v2"
API_TOKEN = "d73c101f44eb69b283f02de64dc307d83b7f323b"

def get_json(endpoint: str, params: dict | None = None) -> dict:
    """Fetch JSON data from a Bzzoiro endpoint.

    Args:
        endpoint: Path fragment without leading slash, e.g. "teams".
        params: Optional query parameters.
    Returns:
        Parsed JSON response as a Python dict.
    Raises:
        requests.HTTPError if the request fails.
    """
    url = f"{API_BASE_URL}/{endpoint}" if not endpoint.startswith('/') else f"{API_BASE_URL}{endpoint}"
    headers = {"Authorization": f"Token {API_TOKEN}"}
    response = requests.get(url, headers=headers, params=params, timeout=30)
    response.raise_for_status()
    return response.json()
