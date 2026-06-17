# test_auth.py
import requests
import json

BASE_URL = "http://localhost:8000/api"

def test_login():
    """Test login endpoint"""
    response = requests.post(
        f"{BASE_URL}/auth/login",
        json={
            "admin_id": "admin",
            "keypass": "1234"
        }
    )
    
    if response.status_code == 200:
        data = response.json()
        print("✅ Login successful!")
        print(f"Token: {data['access_token'][:50]}...")
        return data['access_token']
    else:
        print(f"❌ Login failed: {response.status_code}")
        print(response.json())
        return None

def test_protected_endpoint(token):
    """Test a protected endpoint"""
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(
        f"{BASE_URL}/protected",
        headers=headers
    )
    
    if response.status_code == 200:
        print("✅ Protected endpoint accessible!")
        print(response.json())
    else:
        print(f"❌ Protected endpoint failed: {response.status_code}")
        print(response.json())

def test_admin_endpoint(token):
    """Test an admin-only endpoint"""
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(
        f"{BASE_URL}/admin-only",
        headers=headers
    )
    
    if response.status_code == 200:
        print("✅ Admin endpoint accessible!")
        print(response.json())
    else:
        print(f"❌ Admin endpoint failed: {response.status_code}")
        print(response.json())

if __name__ == "__main__":
    token = test_login()
    if token:
        test_protected_endpoint(token)
        test_admin_endpoint(token)