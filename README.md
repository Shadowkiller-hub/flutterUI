# MyBMTC - Bus Tracking App

A Flutter application for tracking BMTC buses in Bangalore. This app allows users to view bus locations, search for buses, and filter them by number, route, or destination.

## Features

- Real-time bus tracking on Google Maps
- Display of important places (banks, hospitals, food courts)
- Search functionality for buses, routes, and stops
- Filter options for bus search
- Current location tracking
- Clean and intuitive UI

## Screenshots

The app includes:
- Map view with bus locations shown as yellow markers
- Places of interest (banks, hospitals, food courts) with different marker colors
- Search bar with filter options
- Bottom navigation for different sections of the app

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / Xcode
- Google Maps API key (already configured in the app)

### Installation

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Ensure you have the Google Maps API key in the AndroidManifest.xml and AppDelegate.swift files
4. Run the app with `flutter run`

### Required Permissions

- Location access
- Internet access

## Tech Stack

- Flutter
- Google Maps Flutter
- Provider for state management
- Location package for device location

## Note

This app contains mock data for demonstration purposes. In a real-world scenario, it would connect to a backend service to fetch real-time bus location data.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
