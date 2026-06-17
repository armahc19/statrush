import json

def load_mock(file_path):
    with open(file_path, "r") as f:
        return json.load(f)  # Return instead of print

