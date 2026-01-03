# ClubHub Recommendation System

AI-powered event recommendation system for ClubHub using collaborative filtering and content-based matching.

## Features

- 🎯 **Personalized Recommendations** - Based on student interests and past event attendance
- 🔄 **Hybrid Approach** - Combines collaborative and content-based filtering
- 📊 **Real-time Updates** - Pulls latest data from Firestore
- 🚀 **REST API** - Easy integration with Flutter app
- 📈 **Popularity Scoring** - Boosts trending events

## Setup

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Firebase Configuration

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate New Private Key"
3. Save the JSON file as `serviceAccountKey.json` in this directory
4. **NEVER commit this file to git!** (Already in .gitignore)

### 3. Test Firebase Connection

```bash
python test_firebase.py
```

You should see:
```
✅ Firebase connected successfully!
✅ Students collection: X document(s) found
✅ Clubs collection: X document(s) found
✅ Events collection: X document(s) found
```

### 4. Populate Database (Optional)

If you need test data:

```bash
python populate_database.py
```

This will create:
- 12 clubs across different categories
- 40+ events (past and upcoming)
- 80 students with varied interests
- Realistic registrations and attendance

## Running the API

### Development Mode

```bash
python api.py
```

API will be available at:
- Local: http://localhost:5000
- Network: http://0.0.0.0:5000

### Production Mode

```bash
gunicorn -w 4 -b 0.0.0.0:5000 api:app
```

## API Endpoints

### Get Recommendations

```bash
GET /api/recommendations/<student_uid>?top_n=5
```

**Response:**
```json
{
  "studentUid": "abc123",
  "studentName": "John Doe",
  "interests": ["Technology & Programming", "Music & Dance"],
  "type": "hybrid",
  "hasAttendedEvents": true,
  "attendedCount": 5,
  "recommendations": [
    {
      "eventId": "event123",
      "eventName": "Code Sprint 2026",
      "clubName": "CUET Computer Club",
      "clubCategory": "Technology",
      "eventDescription": "Competitive programming...",
      "score": 0.8542
    }
  ]
}
```

### Batch Recommendations

```bash
POST /api/recommendations/batch
Content-Type: application/json

{
  "student_uids": ["uid1", "uid2", "uid3"],
  "top_n": 5
}
```

### Refresh System

```bash
POST /api/refresh
```

Reloads all data from Firestore (use after adding new events).

### Get Statistics

```bash
GET /api/stats
```

**Response:**
```json
{
  "total_students": 80,
  "total_events": 42,
  "total_clubs": 12,
  "total_registrations": 245,
  "upcoming_events": 28
}
```

### Health Check

```bash
GET /health
```

## How It Works

### Recommendation Algorithm

1. **For New Students** (no event history):
   - 95% weight on interest matching
   - 5% weight on event popularity

2. **For Returning Students** (with event history):
   - 60% weight on similarity to attended events
   - 40% weight on interest matching
   - 10% popularity boost

### Interest Matching

Each student interest is mapped to keywords:
- Technology → "programming", "code", "hackathon", "ai", "ml"
- Sports → "football", "cricket", "tournament", "fitness"
- Music → "band", "concert", "singing", "performance"
- etc.

Events are scored based on keyword matches in their name, description, club name, and category.

### Collaborative Filtering

Uses TF-IDF vectorization and cosine similarity to find events similar to ones the student attended.

## Integration with Flutter

### Example: Get Recommendations

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Event>> getRecommendations(String studentUid) async {
  final response = await http.get(
    Uri.parse('http://your-api-url:5000/api/recommendations/$studentUid?top_n=10')
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['recommendations'] as List)
        .map((rec) => Event.fromRecommendation(rec))
        .toList();
  }
  
  throw Exception('Failed to load recommendations');
}
```

## Troubleshooting

### "Firebase connection failed"
- Check if `serviceAccountKey.json` exists
- Verify the JSON file is valid
- Ensure Firebase project is active

### "No recommendations returned"
- Check if student exists in database
- Verify student has interests set
- Ensure there are upcoming events

### "Model building failed"
- Check if events have proper descriptions
- Ensure clubs are linked to events
- Verify data format matches schema

## File Structure

```
recommendation_system/
├── api.py                      # Flask REST API
├── clubhub_recommender.py      # Recommendation engine
├── populate_database.py        # Database population script
├── test_firebase.py            # Firebase connection test
├── requirements.txt            # Python dependencies
├── serviceAccountKey.json      # Firebase credentials (gitignored)
└── README.md                   # This file
```

## Performance

- **Cold start**: ~5-10 seconds (loading data)
- **Recommendation generation**: ~50-200ms per student
- **Batch processing**: ~30-100ms per student (amortized)

## Requirements

- Python 3.8+ (Tested with Python 3.14.1)
- Firebase Firestore database
- 512MB+ RAM
- Network access to Firebase

## Verified Package Versions

All packages have been tested and verified to work together:
- firebase-admin 7.1.0
- flask 3.1.2
- flask-cors 6.0.2
- pandas 2.3.3
- numpy 2.3.5
- scikit-learn 1.7.2
- gunicorn 23.0.0

## Support

For issues or questions, check:
1. Console output for error messages
2. Firebase console for data structure
3. This README for common issues

---

Built with ❤️ for ClubHub
