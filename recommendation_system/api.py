"""
api.py
Flask API for ClubHub event recommendations
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from clubhub_recommender import ClubHubRecommender
import os
import traceback

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

# Initialize recommendation system once on startup
print("🚀 Starting ClubHub Recommendation API...")
FIREBASE_CRED = os.getenv('FIREBASE_CRED_PATH', 'serviceAccountKey.json')

# Check if credentials file exists
if not os.path.exists(FIREBASE_CRED):
    print(f"❌ Error: {FIREBASE_CRED} not found!")
    print("Please place your Firebase service account key in this directory.")
    recommender = None
else:
    try:
        recommender = ClubHubRecommender(FIREBASE_CRED)
        print("✅ Recommendation system ready!")
    except Exception as e:
        print(f"❌ Failed to initialize recommender: {e}")
        import traceback
        traceback.print_exc()
        recommender = None


@app.route('/', methods=['GET'])
def home():
    """API home endpoint"""
    return jsonify({
        'message': 'ClubHub Recommendation API',
        'version': '1.0.0',
        'status': 'running',
        'endpoints': {
            'health': '/health',
            'recommendations': '/api/recommendations/<student_uid>',
            'batch': '/api/recommendations/batch',
            'refresh': '/api/refresh',
            'stats': '/api/stats'
        }
    }), 200


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy' if recommender else 'unhealthy',
        'message': 'Recommendation API is running' if recommender else 'Recommender not initialized'
    }), 200 if recommender else 503


@app.route('/api/recommendations/<student_uid>', methods=['GET'])
def get_recommendations(student_uid):
    """
    Get event recommendations for a student
    
    Query parameters:
        - top_n: Number of recommendations (default: 5, max: 20)
    
    Example: GET /api/recommendations/abc123?top_n=10
    """
    if not recommender:
        return jsonify({
            'error': 'Recommendation system not available',
            'message': 'System is still initializing or failed to start'
        }), 503
    
    try:
        # Get top_n from query parameters
        top_n = request.args.get('top_n', default=5, type=int)
        
        # Validate top_n
        if top_n < 1 or top_n > 20:
            return jsonify({
                'error': 'Invalid top_n parameter',
                'message': 'top_n must be between 1 and 20'
            }), 400
        
        # Get recommendations
        recommendations = recommender.recommend(student_uid, top_n=top_n)
        
        # Check for errors
        if recommendations.get('type') == 'error':
            return jsonify(recommendations), 404
        
        return jsonify(recommendations), 200
        
    except Exception as e:
        print(f"❌ Error in get_recommendations: {str(e)}")
        traceback.print_exc()
        return jsonify({
            'error': 'Internal server error',
            'message': str(e)
        }), 500


@app.route('/api/recommendations/batch', methods=['POST'])
def get_batch_recommendations():
    """
    Get recommendations for multiple students at once
    
    Request body:
    {
        "student_uids": ["uid1", "uid2", "uid3"],
        "top_n": 5
    }
    
    Response:
    {
        "total": 3,
        "recommendations": [
            { "studentUid": "uid1", "recommendations": [...] },
            { "studentUid": "uid2", "recommendations": [...] },
            ...
        ]
    }
    """
    if not recommender:
        return jsonify({
            'error': 'Recommendation system not available'
        }), 503
    
    try:
        data = request.get_json()
        
        if not data or 'student_uids' not in data:
            return jsonify({
                'error': 'Missing required field: student_uids'
            }), 400
        
        student_uids = data['student_uids']
        top_n = data.get('top_n', 5)
        
        if not isinstance(student_uids, list):
            return jsonify({
                'error': 'student_uids must be an array'
            }), 400
        
        if len(student_uids) > 50:
            return jsonify({
                'error': 'Maximum 50 students per batch request'
            }), 400
        
        # Get recommendations for each student
        results = []
        for uid in student_uids:
            try:
                rec = recommender.recommend(uid, top_n=top_n)
                results.append(rec)
            except Exception as e:
                print(f"Error for student {uid}: {e}")
                results.append({
                    'studentUid': uid,
                    'type': 'error',
                    'message': str(e),
                    'recommendations': []
                })
        
        return jsonify({
            'total': len(results),
            'recommendations': results
        }), 200
        
    except Exception as e:
        print(f"❌ Error in batch_recommendations: {str(e)}")
        traceback.print_exc()
        return jsonify({
            'error': 'Internal server error',
            'message': str(e)
        }), 500


@app.route('/api/refresh', methods=['POST'])
def refresh_data():
    """
    Refresh the recommendation system with latest data from Firestore
    Call this endpoint after adding new events or registrations
    
    Warning: This reloads all data and rebuilds the model - may take 10-30 seconds
    """
    global recommender
    
    try:
        print("🔄 Refreshing recommendation system...")
        recommender = ClubHubRecommender(FIREBASE_CRED)
        print("✅ Refresh complete!")
        
        return jsonify({
            'status': 'success',
            'message': 'Recommendation system refreshed successfully'
        }), 200
        
    except Exception as e:
        print(f"❌ Error refreshing: {str(e)}")
        traceback.print_exc()
        return jsonify({
            'error': 'Failed to refresh system',
            'message': str(e)
        }), 500


@app.route('/api/stats', methods=['GET'])
def get_stats():
    """Get system statistics"""
    if not recommender:
        return jsonify({
            'error': 'Recommendation system not available'
        }), 503
    
    try:
        stats = {
            'total_students': len(recommender.students_df),
            'total_events': len(recommender.events_df),
            'total_clubs': len(recommender.clubs_df),
            'total_registrations': len(recommender.registrations_df),
            'upcoming_events': len(recommender.events_df[
                recommender.events_df['eventId'].apply(recommender._is_upcoming)
            ])
        }
        
        return jsonify(stats), 200
        
    except Exception as e:
        print(f"❌ Error getting stats: {str(e)}")
        return jsonify({
            'error': 'Failed to get stats',
            'message': str(e)
        }), 500


@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'error': 'Endpoint not found',
        'message': 'The requested URL was not found on the server'
    }), 404


@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        'error': 'Internal server error',
        'message': 'An unexpected error occurred'
    }), 500


if __name__ == '__main__':
    # For development
    print("\n" + "="*60)
    print("🚀 ClubHub Recommendation API")
    print("="*60)
    print("📍 Local: http://localhost:5000")
    print("📍 Network: http://0.0.0.0:5000")
    print("="*60 + "\n")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
    
    # For production, use gunicorn:
    # gunicorn -w 4 -b 0.0.0.0:5000 api:app