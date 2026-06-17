from flask import Flask, jsonify, request  # Add 'request' here
from flask_cors import CORS
from routes.stats_routes import stats_bp
from dotenv import load_dotenv
from auth import init_auth_routes, token_required, admin_required
import os

load_dotenv()
app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

# Initialize auth routes
init_auth_routes(app)

app.register_blueprint(stats_bp, url_prefix="/api")

# Add a protected test route
@app.route('/api/protected', methods=['GET'])
@token_required
def protected_route():
    return jsonify({
        "status": "success",
        "message": "You have access to this protected route",
        "user": request.user
    })

# Add an admin-only test route
@app.route('/api/admin-only', methods=['GET'])
@admin_required
def admin_only_route():
    return jsonify({
        "status": "success",
        "message": "You have admin access",
        "user": request.user
    })

if __name__ == "__main__":
    app.run(debug=True)