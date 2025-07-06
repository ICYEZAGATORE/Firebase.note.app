# Firebase Notes App

This is a simple Flutter note-taking app that uses Firebase Authentication (email/password) and Cloud Firestore to manage notes. It supports creating an account, logging in, and performing full CRUD (Create, Read, Update, Delete) operations on user-specific notes.

## Setup Steps

1. Install Flutter dependencies:
flutter pub get

2. Go to https://console.firebase.google.com and create a new Firebase project.

3. Register your Android app in the Firebase console using your package name (e.g., com.example.noteapp).

4. Download the google-services.json file and place it inside android/app/.

5. In android/build.gradle, inside buildscript > dependencies, add:
classpath 'com.google.gms:google-services:4.3.15'

6. In android/app/build.gradle, at the bottom of the file, add:
apply plugin: 'com.google.gms.google-services'

7. Enable Firestore in the Firebase console. Start in test mode or use these secure rules:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
    }
  }
}

8. Connect your emulator or device and run:
flutter run

## Features

- Sign up and log in with email and password
- View all your notes after login
- Add new notes with the ➕ button
- Edit or delete existing notes
- If there are no notes, shows message: “Nothing here yet—tap ➕ to add a note.”

## Errors You Might Encounter

- Permission Denied → Fix Firestore security rules
- Query Requires Index → Click the generated Firebase console link to create the index
- Gradle Sync Errors → Ensure you have internet and correct Firebase versions
- Emulator Slow or Crashing → Use physical device or check virtualization settings

## Project Uses

- flutter_bloc for state management
- firebase_auth for authentication
- cloud_firestore for storing and retrieving notes

Everything is handled cleanly using Bloc, and all major logic is separated from the UI. A loading spinner is shown when fetching data, and SnackBars show success or error messages.
