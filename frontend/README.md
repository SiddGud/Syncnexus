# SyncNexus Frontend - Flutter App

Welcome to the SyncNexus frontend repository for the Flutter app! This repository contains the codebase for the SyncNexus mobile app frontend, built using the Flutter framework. The app provides a user-friendly interface for accessing the SyncNexus platform's features on mobile devices, enabling seamless job searching, task management, communication, and more.

## Project Links

This section contains links to the frontend and backend repositories, as well as the base URL and documentation for the backend API.

### Frontend Repository
- Repository URL: [Frontend Repo - https://github.com/Ahmedazim7804/SyncNexus-Frontend](https://github.com/Ahmedazim7804/SyncNexus-Frontend)

### Backend Repository
- Repository URL: [Backend Repo - https://github.com/atishayj2202/SyncNexus-Backend](https://github.com/atishayj2202/SyncNexus-Backend)

### Backend API Endpoint Base URL
- Base URL: https://google-solution-challenge-backend-jpnacpp5ta-em.a.run.app

### Backend API Endpoint Documentation
- Documentation URL: https://google-solution-challenge-backend-jpnacpp5ta-em.a.run.app/docs

## Technologies Used
- **Framework**: Flutter
- **Programming Language**: Dart
- **State Management**: Provider / Bloc
- **HTTP Requests**: Dio / http package
- **Navigation**: GoRouter
- **Authentication**: OAuth 2.0 (e.g., Google Sign-In)
- **Deployment**: Google Play Store / Apple App Store

## Project Structure
The Flutter app project follows the Flutter recommended project structure, which organizes code into various directories for better maintainability and scalability. Here's an overview of the main directories:
- **lib/screens**: Contains screen-level widgets representing different sections of the app (e.g., HomeScreen, JobsScreen, TasksScreen).
- **lib/widgets**: Houses reusable UI widgets used across the app.
- **lib/providers**: Manages application state using Provider or Bloc pattern, including state management logic and data models.
- **lib/services**: Contains service classes for handling API requests, authentication, and other backend-related functionalities.
- **lib/utils**: Houses utility functions and helper classes used across the project.

## Screenshots
<p float="left">
  <img src="screenshots/employer_1.png" alt="Screenshot Gallery" width="160"/>
  <img src="screenshots/employer_2.png" alt="Screenshot Gallery" width="160"/>
</p>
<p float="left">
  <img src="screenshots/employee_1.png" alt="Screenshot Gallery" width="160"/>
  <img src="screenshots/Employee_2.png" alt="Screenshot Gallery" width="160"/>
</p>

## Setup Instructions
To set up the Flutter app locally for development, follow these steps:
1. Clone the repository: `git clone <repository-url>`
2. Navigate to the project directory: `cd syncnexus-flutter-app`
3. Ensure Flutter SDK is installed and configured on your machine.
4. Run `flutter pub get` to install dependencies.
5. Set up environment variables (e.g., API base URL, OAuth client ID).
6. Run the app on a simulator or physical device using `flutter run`.

## Deployment
The Flutter app can be deployed to the Google Play Store for Android devices and the Apple App Store for iOS devices. Follow these steps for deployment:
1. Build the app for release: `flutter build apk` (for Android) or `flutter build ios` (for iOS).
2. Follow the respective platform's guidelines for preparing and submitting the app for review and publication.
3. Configure environment variables in the deployment environment for sensitive data (e.g., API base URL).

## Contributers
- Ajeem Ahmad
- Atishay Jain
- Tanmay Gupta
- Siddhant Gudwani

## License
This project is licensed under the [MIT License](LICENSE).
