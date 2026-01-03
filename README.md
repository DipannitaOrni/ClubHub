<div align="center">

# 🎓 ClubHub

### Campus Club Management Made Simple

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
</p>

<p align="center">
A mobile app that makes campus club management actually work. Built with Flutter and Firebase.
</p>

</div>

---

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

## 🛠️ Tech Stack

<table>
<tr>
<td align="center" width="200">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
<br><strong>Frontend</strong>
</td>
<td align="center" width="200">
<img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase"/>
<br><strong>Backend & Auth</strong>
</td>
<td align="center" width="200">
<img src="https://img.shields.io/badge/Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firestore"/>
<br><strong>Database</strong>
</td>
<td align="center" width="200">
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"/>
<br><strong>Recommendations</strong>
</td>
</tr>
</table>

## 🚀 Getting Started

### 📋 Prerequisites

<table>
<tr>
<td>
<img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" alt="Flutter"/>
</td>
<td>Flutter SDK (latest stable version)</td>
</tr>
<tr>
<td>
<img src="https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black" alt="Firebase"/>
</td>
<td>Firebase account</td>
</tr>
<tr>
<td>
<img src="https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white" alt="Python"/>
</td>
<td>Python 3.x (for recommendation system)</td>
</tr>
</table>

### 💻 Installation

**1️⃣ Clone the repo**
```bash
git clone https://github.com/DipannitaOrni/ClubHub.git
cd ClubHub
```

**2️⃣ Install Flutter dependencies**
```bash
flutter pub get
```

**3️⃣ Set up Firebase**
   - Create a Firebase project
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update `lib/firebase_options.dart` with your config

**4️⃣ Run the app**
```bash
flutter run
```

### 🤖 Setting up the Recommendation System (Optional)

The recommendation system helps suggest clubs to students based on their interests.

```bash
cd recommendation_system
pip install -r requirements.txt
python api.py
```

## 📂 Project Structure

```
lib/
├── 📁 models/          # Data models (Club, Event, Student, etc.)
├── 📁 providers/       # State management
├── 📁 screens/         # UI screens
│   ├── 🔐 auth/        # Login & signup
│   ├── 👨‍🎓 student/     # Student-specific screens
│   └── 👔 club_manager/ # Club manager screens
├── 📁 services/        # Firebase & API services
├── 📁 utils/           # Constants & themes
└── 📁 widgets/         # Reusable components

recommendation_system/
├── 🐍 api.py           # Recommendation API
├── 🧠 clubhub_recommender.py  # Recommendation logic
└── 📄 requirements.txt
```

## 🔄 How It Works

1. **Sign Up**: Students and club managers create accounts
2. **Authentication**: Firebase handles user authentication
3. **For Students**: Browse clubs, request to join, view events
4. **For Managers**: Review requests, manage members, create events
5. **Recommendations**: Python backend analyzes student interests and suggests clubs

## 🤝 Contributing

This is a student project, but feel free to fork it and make improvements!

## 📄 License

This project is open source and available under the MIT License.
