# Runa

A Flutter project with Firebase integration and Gemini AI.

## Setup Instructions

### Prerequisites

1. Install Flutter SDK
2. Install Firebase CLI: `npm install -g firebase-tools`
3. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`

### Firebase Configuration

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable the following services:
   - Authentication
   - Firestore Database
   - Gemini AI (Vertex AI)
3. Copy `lib/firebase_options.dart.example` to `lib/firebase_options.dart`
4. Run `flutterfire configure` and select your Firebase project
5. This will automatically update your `firebase_options.dart` file with the correct configuration

### Running the Project

```bash
flutter pub get
flutter run
```

## Features

- Firebase Authentication
- Gemini AI Integration
- Cross-platform support (Windows, Android, iOS, Web)

## Security Note

The `firebase_options.dart` file is excluded from version control for security reasons. You'll need to configure it locally using the steps above.
