from mock_loader import load_mock

def get_event(event_file):
    return load_mock(event_file)

def get_incidents(incident_file):
    return load_mock(incident_file)


