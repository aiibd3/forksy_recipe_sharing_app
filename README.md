# Forksy

## Getting Started

This report was created by **Abdulrahman Hamoud** as part of the task for developing a **Recipe Sharing Application** using Flutter. This project was developed for the second stage of an interview process. The report outlines the decision-making process behind selecting Firebase Cloud Services as the storage solution for the application. It also provides insights into the planning, implementation, and benefits of using Firebase within the project.
[Second Interview Report.pdf](https://github.com/user-attachments/files/18255646/Second.Interview.Report.pdf)

---

# Forksy

A **Recipe Sharing Application** built using **Flutter**. This app enables users to share, view, and manage recipes with media uploads and real-time updates, leveraging **Firebase** for storage, authentication, and database management.

---
##Install Dependencies
- flutter pub get
- flutter run
- flutter config --enable-web


## Features

- Push Notifications with NotificationService
- User Authentication (Sign Up, Login, Logout)
- Recipe Feed with Real-Time Updates
- Media Upload and Retrieval (Images)
- Secure Data Storage with Firebase
- Cross-Platform Support (Android, iOS, Web)

```
forksy/
forksy/
├── lib/
│   ├── core/
│   │   ├── api/           # API-related logic and network services
│   │   ├── constants/     # Application-wide constant values
│   │   ├── cubit/         # Global Cubit states (BLoC-related)
│   │   ├── di/            # Dependency injection setup and configurations
│   │   ├── errors/        # Error handling utilities and classes
│   │   ├── extensions/    # Dart and Flutter extension methods
│   │   ├── models/        # Data models shared across the app
│   │   ├── routing/       # App routing/navigation setup
│   │   ├── services/      # Shared services (e.g., notifications, analytics)
│   │   ├── theme/         # App-wide styling (colors, fonts, etc.)
│   │   ├── utils/         # Utility functions and helpers
│   │   └── widgets/       # Reusable UI components
│   ├── features/
│   │   ├── auth/          # User authentication (login, signup, etc.)
│   │   ├── layout/        # Reusable UI layout components
│   │   ├── onboarding/    # Onboarding flow for new users
│   │   ├── post/          # Managing posts (recipes, interactions)
│   │   ├── profile/       # User profile management
│   │   ├── splash/        # Splash screen and initial app loading
│   │   └── storage/       # Firebase Storage handling for media
│   └── main.dart          # Main entry point of the application
├── android/               # Android-specific configurations
├── ios/                   # iOS-specific configurations
├── web/                   # Web-specific configurations
├── pubspec.yaml           # Dependencies and assets
└── README.md              # Project documentation


```
---

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter**: [Install Flutter](https://flutter.dev/docs/get-started/install)
   - Run `flutter doctor` to verify installation.
2. **Firebase CLI**: [Install Firebase CLI](https://firebase.google.com/docs/cli)
3. **Dart**: Comes pre-installed with Flutter.
4. **Git**: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

---

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/your-username/forksy.git
cd forksy
```

## Firebase Cloud Services: Selection Criteria

For the development of the Recipe Sharing Application, **Firebase Cloud Services** was chosen as the primary storage solution for managing media and app data. The decision was based on several factors, including:

- **Ease of Integration**: Firebase offers seamless integration with Flutter through its official SDKs, enabling efficient media uploads, retrievals, and management with minimal development overhead.
- **Scalability**: Firebase Storage dynamically scales to meet the application's needs, handling increased user numbers and storage demands without additional configuration.
- **Pricing**: Firebase provides a pay-as-you-go model. For small to medium-scale applications like this one, the free tier covers initial usage, making it a cost-effective choice.
- **Global Availability**: Firebase operates data centers worldwide, ensuring high availability and a better user experience regardless of geographical location.
- **Security**: Firebase Security Rules allow fine-grained access control, ensuring data privacy and secure storage.

---

## Comparison with Alternatives

1. **Amazon S3**:
   - Pros:
     - Powerful and robust storage solution.
   - Cons:
     - Complex integration and configuration for smaller projects.
     - Requires third-party setup for Flutter compatibility.
   - Firebase Advantage:
     - Out-of-the-box support for Flutter.
     - Real-time synchronization with Firestore.

2. **Supabase Storage**:
   - Pros:
     - Integrates well with Flutter.
   - Cons:
     - Smaller ecosystem compared to Firebase.
   - Firebase Advantage:
     - Established ecosystem, broader toolset, and larger community support.

---

## Implementation Plan

1. **Planning**:
   - Spent approximately 5 hours brainstorming, exploring options, and outlining tools and services.
   - Defined the app's structure and integration steps.

2. **Authentication**:
   - Implemented Firebase Authentication for signup, login, and logout functionalities.
   - Total Time: 8 hours.

3. **Media Upload and Retrieval**:
   - Users upload images via the app, which are stored in Firebase Storage, with references saved in Firestore.
   - Recipe images are fetched and displayed using stored URLs.
   - Total Time: 4 hours for each section.

---

## Database Selection Report

### 1. Selection Criteria
The database was chosen based on:
- **Real-Time Capabilities**: Instant data synchronization across devices.
- **Ease of Use**: Simple integration and minimal backend setup.
- **Scalability**: Ability to handle growth without complex configurations.
- **Cross-Platform Support**: Native support for web, iOS, and Android.
- **Security**: Built-in rules for controlling data access.
- **Cost**: Flexible pricing based on usage.

### 2. Comparison of Firebase Databases

#### **Chosen Database**: Firebase Realtime Database
- **Pros**:
  - Designed for real-time synchronization, ideal for instant updates.
  - Simple and fast to implement.
  - Cost-effective for small-scale projects.
- **Cons**:
  - Limited querying capabilities compared to Firestore.
  - Less scalable for complex data structures due to flat JSON format.

#### **Alternative**: Firebase Firestore
- **Pros**:
  - Advanced querying and indexing capabilities.
  - Better suited for larger, complex data sets.
  - Native offline access across platforms.
- **Cons**:
  - Slightly higher cost for real-time features.
  - More complex setup compared to Realtime Database.

### 3. Why Firebase Realtime Database?
For this project:
- Real-time updates were critical.
- The simplicity and affordability of Realtime Database aligned with the app's requirements.

---

## Firebase Realtime Database: Implementation Plan

1. **Data Structure**:
   - Flat JSON structure for efficient real-time synchronization.
   - Example Nodes:
     - `/users`: Stores user profiles and settings.
     - `/recipes`: Stores recipe details.
     - `/uploads`: Tracks media uploads.

2. **Integration**:
   - Integrated Firebase SDKs into the app.
   - Secured user access with Firebase Authentication.
   - Applied Firebase Security Rules to restrict read/write access based on roles.

3. **Hosting and Scaling**:
   - Firebase automatically manages hosting and scaling, eliminating manual configuration.

4. **Optimization**:
   - Structured data to minimize reads/writes.
   - Used indexing for frequently queried data.

---

## Conclusion

The **Firebase Realtime Database** and **Firebase Storage** were chosen for their simplicity, real-time functionality, and seamless integration, making them ideal for this Recipe Sharing Application. The project successfully demonstrates the efficiency of Firebase in small to medium-scale Flutter applications.
