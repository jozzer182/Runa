# Firebase Configuration Setup

## Prerequisites
1. Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/)
2. Add an Android app to your Firebase project

## Setup Instructions

### 1. Download google-services.json
1. In the Firebase Console, go to Project Settings
2. In the "Your apps" section, click on your Android app
3. Download the `google-services.json` file

### 2. Place the Configuration File
- Copy the downloaded `google-services.json` file to `android/app/google-services.json`
- **NEVER commit this file to version control** (it's already in .gitignore)

### 3. Package Name
Make sure your Firebase Android app is configured with the package name:
```
com.zarabandajose.runa
```

### 4. Example File
An example structure is provided in `google-services.json.example` for reference.

## Security Notes
- The `google-services.json` file contains sensitive API keys and project information
- This file is automatically ignored by Git for security reasons
- Each developer should obtain their own copy from the Firebase Console
- For production, use different Firebase projects for different environments (dev/staging/prod)

## Troubleshooting
- If you get build errors, ensure the `google-services.json` file is in the correct location
- Verify the package name matches between your app and Firebase configuration
- Make sure you have internet connectivity when building (for Firebase SDK downloads)
