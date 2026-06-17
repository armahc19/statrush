# auth.py
import jwt
import bcrypt
from functools import wraps
from flask import request, jsonify, current_app
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv

load_dotenv()

SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key-change-in-production')
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 60

# In production, store this in a database
# This is for demonstration only
ADMIN_CREDENTIALS = {
    "admin": {
        # Password: 1234 (hashed with bcrypt)
        "password_hash": bcrypt.hashpw("1234".encode('utf-8'), bcrypt.gensalt()).decode('utf-8'),
        "role": "super_admin"
    }
}

def create_access_token(data: dict):
    """Create JWT token"""
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({
        "exp": expire,
        "iat": datetime.utcnow()
    })
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def verify_token(token: str):
    """Verify JWT token"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None

def token_required(f):
    """Decorator to protect routes with JWT token"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        # Check if token is in headers
        auth_header = request.headers.get('Authorization')
        if auth_header and auth_header.startswith('Bearer '):
            token = auth_header.split(' ')[1]
        
        if not token:
            return jsonify({
                "status": "error",
                "message": "Token is missing"
            }), 401
        
        payload = verify_token(token)
        if not payload:
            return jsonify({
                "status": "error",
                "message": "Invalid or expired token"
            }), 401
        
        # Add user info to request context
        request.user = payload
        return f(*args, **kwargs)
    return decorated

def admin_required(f):
    """Decorator to protect routes with admin role check"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        auth_header = request.headers.get('Authorization')
        if auth_header and auth_header.startswith('Bearer '):
            token = auth_header.split(' ')[1]
        
        if not token:
            return jsonify({
                "status": "error",
                "message": "Token is missing"
            }), 401
        
        payload = verify_token(token)
        if not payload:
            return jsonify({
                "status": "error",
                "message": "Invalid or expired token"
            }), 401
        
        # Check if user has admin role
        if payload.get('role') != 'super_admin':
            return jsonify({
                "status": "error",
                "message": "Insufficient permissions"
            }), 403
        
        request.user = payload
        return f(*args, **kwargs)
    return decorated

def init_auth_routes(app):
    """Initialize authentication routes"""
    
    @app.route('/api/auth/login', methods=['POST'])
    def login():
        """Login endpoint"""
        data = request.get_json()
        
        if not data:
            return jsonify({
                "status": "error",
                "message": "Missing request data"
            }), 400
        
        admin_id = data.get('admin_id')
        password = data.get('keypass')
        
        if not admin_id or not password:
            return jsonify({
                "status": "error",
                "message": "Missing admin_id or keypass"
            }), 400
        
        # Check if admin exists
        admin = ADMIN_CREDENTIALS.get(admin_id)
        if not admin:
            return jsonify({
                "status": "error",
                "message": "Invalid credentials"
            }), 401
        
        # Verify password (in production, use bcrypt)
        if not bcrypt.checkpw(password.encode('utf-8'), admin['password_hash'].encode('utf-8')):
            return jsonify({
                "status": "error",
                "message": "Invalid credentials"
            }), 401
        
        # Create access token
        token = create_access_token({
            "sub": admin_id,
            "role": admin['role']
        })
        
        return jsonify({
            "status": "success",
            "access_token": token,
            "token_type": "bearer",
            "expires_in": ACCESS_TOKEN_EXPIRE_MINUTES * 60
        }), 200
    
    @app.route('/api/auth/verify', methods=['POST'])
    def verify():
        """Verify token endpoint"""
        token = None
        auth_header = request.headers.get('Authorization')
        
        if auth_header and auth_header.startswith('Bearer '):
            token = auth_header.split(' ')[1]
        
        if not token:
            return jsonify({
                "status": "error",
                "message": "Token is missing"
            }), 401
        
        payload = verify_token(token)
        if not payload:
            return jsonify({
                "status": "error",
                "message": "Invalid or expired token"
            }), 401
        
        return jsonify({
            "status": "success",
            "authenticated": True,
            "admin_id": payload.get('sub'),
            "role": payload.get('role')
        }), 200
    
    @app.route('/api/auth/logout', methods=['POST'])
    def logout():
        """Logout endpoint (client-side token removal)"""
        return jsonify({
            "status": "success",
            "message": "Logged out successfully"
        }), 200