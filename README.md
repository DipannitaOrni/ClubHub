# ClubHub

A mobile app that makes campus club management actually work. Built with Flutter and Firebase.

## What is this?

ClubHub is a platform where students can discover and join clubs, while club managers can handle everything from member requests to event planning. No more endless email chains or lost spreadsheets.

## Features

### For Students
- Browse all clubs on campus with details about what they do
- See past events to understand how active a club really is
- Request to join clubs you're interested in
- Track your club memberships
- View upcoming events from your joined clubs
- Get personalized club recommendations based on your interests

### For Club Managers
- Accept or reject join requests
- Manage club members
- Create and manage events
- Assign leadership roles (President, Secretary, etc.)
- View club statistics (total members, completed events)
- Update club information

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Firestore, Authentication)
- **Recommendation System**: Python (runs separately)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase account
- Python 3.x (for recommendation system)

### Installation

1. Clone the repo
```bash
git clone https://github.com/yourusername/ClubHub.git
cd ClubHub
```

2. Install Flutter dependencies
```bash
flutter pub get
```

3. Set up Firebase
   - Create a Firebase project
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update `lib/firebase_options.dart` with your config

4. Run the app
```bash
flutter run
```

### Setting up the Recommendation System (Optional)

The recommendation system helps suggest clubs to students based on their interests.

```bash
cd recommendation_system
pip install -r requirements.txt
python api.py
```

## Project Structure

```
lib/
├── models/          # Data models (Club, Event, Student, etc.)
├── providers/       # State management
├── screens/         # UI screens
│   ├── auth/        # Login & signup
│   ├── student/     # Student-specific screens
│   └── club_manager/ # Club manager screens
├── services/        # Firebase & API services
├── utils/           # Constants & themes
└── widgets/         # Reusable components

recommendation_system/
├── api.py           # Recommendation API
├── clubhub_recommender.py  # Recommendation logic
└── requirements.txt
```

## How It Works

1. **Sign Up**: Students and club managers create accounts
2. **Authentication**: Firebase handles user authentication
3. **For Students**: Browse clubs, request to join, view events
4. **For Managers**: Review requests, manage members, create events
5. **Recommendations**: Python backend analyzes student interests and suggests clubs

## Database Maintenance Scripts

A few utility scripts are included to keep your Firestore data clean:

- `fix_clubids.py` - Ensures all clubs and join requests have proper clubId fields
- `fix_completed_events.py` - Updates club statistics based on actual past events

Run these if you notice data inconsistencies.

## Known Issues

- Make sure all Firestore documents have the required fields (clubId, etc.)
- The app expects clubs to have leadership roles assigned for proper display

## Contributing

This is a student project, but feel free to fork it and make improvements!

## License

This project is open source and available under the MIT License.
