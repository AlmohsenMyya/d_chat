# D-Chat — Engineering a Production-Ready Real-Time System

<p align="center">
  <img src="assets/logo.png" alt="D-chat Logo" width="150"/>
</p>

<p align="center">
  <strong>A high-performance, real-time messaging platform built with Flutter and Firebase.</strong>
</p>

---

## 🎯 The Philosophy

**D-Chat is not just another chat application; it is a case study in Software Engineering.** The primary goal of this project was to demonstrate how to design, architect, and evolve a scalable system using **Clean Architecture principles, Agile (Scrum) methodology, and smart Backend engineering**. The emphasis is on *how* the system operates under the hood—handling edge cases, ensuring data consistency, and minimizing cloud costs—rather than merely stacking features.

---

## 🏗️ System Architecture

D-Chat strictly enforces a layered architecture. The UI knows nothing about the database, and the business logic is entirely decoupled from external APIs.

    📱 Presentation Layer (Dumb UI - Flutter Widgets)
          ↓ listens to / triggers
    🧠 State Management Layer (Providers / Change Notifiers)
          ↓ calls
    🛠️ Data & Service Layer (Isolated Services / Dependency Injection)
          ↓ communicates with
    ☁️ External Systems (Firestore / RTDB / Cloudinary / FCM)

### Core Architectural Principles:
* **Dumb UI:** Widgets are strictly for rendering. No `FirebaseFirestore.instance` or complex logic exists inside any UI file.
* **Smart Dependency Injection:** Utilizing `MultiProvider` and `ProxyProvider` to inject services dynamically based on authentication state without memory leaks.
* **Separation of Concerns:** Media handling, connectivity monitoring, and database routing are abstracted into dedicated, isolated services.

---

## 🔬 Engineering Masterpieces (Under the Hood)

D-Chat tackles real-world distributed system challenges with innovative, cost-effective solutions:

### 1. The Dual-Database Presence System (Solving the "Ghost Online" Bug)
Relying solely on Firestore for online/offline status leads to inaccurate data if the app crashes or loses internet. 
* **The Solution:** Integrated **Firebase Realtime Database (RTDB)** utilizing the `.onDisconnect()` hook. If the user's socket drops unexpectedly, the server automatically updates their status, which is then securely bridged to Firestore.

### 2. Client-Side FCM v1 (Serverless Push Notifications)
Firebase Cloud Functions require a paid Blaze plan. To keep this project cost-free while maintaining enterprise features:
* **The Solution:** Built a secure client-side trigger using `googleapis_auth` to generate OAuth2 Access Tokens on the fly. The sender's device communicates directly with the **FCM v1 REST API** to push notifications to the receiver instantly.

### 3. Surgical Storage Migration (Cloudinary Integration)
To prove the resilience of the Clean Architecture, Firebase Storage was completely swapped out for **Cloudinary** midway through development.
* **The Solution:** By updating only the `MediaService` and `ChatService` to use Cloudinary's REST API (with dynamic scale/quality transformations), the migration was completed **without modifying a single line of UI or Provider code**.

### 4. Resilience & Edge-Case Handling
* **Global Connectivity Wrapper:** A custom stream listener that monitors network state globally, rendering an elegant "Offline Mode" drop-down bar instantly without disrupting the user flow.
* **Atomic Batch Writes:** Messages and chat metadata (unread counts, last message, timestamps) are updated via `Firestore.batch()` to guarantee 100% data consistency.

---

## 📱 Features & Capabilities

| Category | Features | Tech Stack |
| :--- | :--- | :--- |
| **Messaging** | 1-on-1 Real-time chat, Read receipts (Ticks), Instant delivery | Firestore Streams + Batch Updates |
| **Media** | Profile and Chat images with dynamic quality/scale optimization | Cloudinary REST API + Media Service |
| **Presence** | Reliable Online/Offline tracking & Last Seen (App Lifecycle aware) | Realtime Database + WidgetsBindingObserver |
| **Alerts** | Secure client-side FCM v1 Push Notifications (OAuth2 powered) | Firebase Cloud Messaging + googleapis_auth |
| **Connectivity** | Global real-time internet monitoring with Floating Alert UI | connectivity_plus + Custom Wrapper |
| **User Discovery** | Real-time searchable user directory with instant filtering | Firestore + Provider Logic |
| **Privacy & Security**| Toggle-based Privacy (Last seen, Read receipts), Local storage | SharedPreferences + PrivacyProvider |
| **Support & Info** | Interactive FAQ (ExpansionTiles), About Screen, Developer Profile | Material 3 + url_launcher |

---

## 🛤️ The Agile Journey (Sprints)

This project was built iteratively over 7 Sprints, reflecting a professional SDLC:

* **Sprint 1 & 2:** Architecture foundation, Theming, Localization, and Auth (`Dumb UI` + `AuthProvider`).
* **Sprint 3:** User discovery, real-time search, and Navigation Service implementation.
* **Sprint 4:** The Communication Layer (Atomic message delivery, Chat Models).
* **Sprint 5:** System Behavior (Presence Engine, Cloudinary Media, FCM Push Notifications).
* **Sprint 6:** Personalization (Profile updating, Global Settings).
* **Sprint 7:** Production Polish (Connectivity Wrapper, Empty States, E2E Testing).

---

## 🛠️ Tech Stack

* **Frontend:** Flutter, Provider, Google Fonts, Shimmer.
* **Backend:** Firebase (Auth, Firestore, Realtime Database, Cloud Messaging).
* **Media Storage:** Cloudinary REST API.
* **Utilities:** `connectivity_plus`, `googleapis_auth`, `flutter_dotenv`, `shared_preferences`.

---

## 🚀 Getting Started

### Prerequisites
1. Flutter SDK (`>=3.11.1`).
2. A Firebase Project (with Auth, Firestore, RTDB, and FCM enabled).
3. A Cloudinary Account.

### Installation

1. Clone the repository:
    git clone https://github.com/AlmohsenMyya/d_chat.git

2. Install dependencies:
    flutter pub get

3. Create a `.env` file in the root directory and add your credentials:
    FIREBASE_PROJECT_ID=your_project_id
    FCM_PRIVATE_KEY_ID=your_private_key_id
    FCM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYourKeyHere\n-----END PRIVATE KEY-----\n"
    FCM_CLIENT_EMAIL=your_client_email
    FCM_CLIENT_ID=your_client_id
    CLOUDINARY_URL=your_cloudinary_url
    CLOUDINARY_UPLOAD_PRESET=your_preset

4. Run the app:
    flutter run

---

## 👨‍💻 Author

**Almohsen Myya** *Software Engineer — Mobile Systems* Passionate about building scalable, maintainable, and highly resilient applications.

[LinkedIn](https://www.linkedin.com/in/almohsen-myya-79230022b) • [GitHub](https://github.com/AlmohsenMyya)

---
> *"A system is not defined by its features, but by how those features integrate cleanly and scale reliably."*
