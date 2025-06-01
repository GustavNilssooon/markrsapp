# Markrs - Service Marketplace App

Markrs is an iOS app that connects people who need services with those who can provide them. Users can post jobs like lawn mowing, fence painting, trash pickup, car washing, and more. Service providers can browse and accept jobs, creating a seamless marketplace for local services.

## Features

- User authentication with email and password
- Post jobs with title, description, price, and images
- Browse available jobs in a modern, card-based interface
- Accept jobs and track their status
- Manage posted and accepted jobs
- User profiles with ratings and job history
- Real-time updates using Firebase
- Modern SwiftUI interface

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.5+
- Firebase account and project

## Installation

1. Clone the repository
2. Install dependencies using Swift Package Manager
3. Create a Firebase project and download the `GoogleService-Info.plist` file
4. Add the `GoogleService-Info.plist` file to your Xcode project
5. Run the app in Xcode

## Firebase Setup

1. Go to the [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Add an iOS app to your Firebase project
4. Download the `GoogleService-Info.plist` configuration file
5. Enable Authentication with Email/Password in the Firebase Console
6. Create a Cloud Firestore database
7. Set up Storage for image uploads

## Dependencies

- Firebase iOS SDK
  - Authentication
  - Cloud Firestore
  - Storage
- SDWebImageSwiftUI for image loading and caching

## Usage

### For Job Posters

1. Create an account or sign in
2. Tap the "Post Job" tab
3. Fill in job details:
   - Title
   - Description
   - Price
   - Location
   - Add photos (optional)
4. Post the job
5. Track job status in "My Jobs"
6. Confirm completion when the job is done

### For Service Providers

1. Create an account or sign in
2. Browse available jobs in the main feed
3. View job details and accept interesting jobs
4. Complete jobs and mark them as finished
5. Track accepted jobs in "My Jobs"

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- Models: Define the data structure (User, Job)
- Views: SwiftUI views for the user interface
- ViewModels: Handle business logic and data management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 