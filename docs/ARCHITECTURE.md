# D-chat — System Architecture

---

## 1. Overview

The system follows a layered architecture to ensure separation of concerns, scalability, and maintainability.

State management is handled using Provider.

---

## 2. Architecture Style

The application uses:

* Layered Architecture
* Provider (ChangeNotifier) for state management

---

## 3. Layers

---

### 3.1 Presentation Layer

Responsible for UI and user interaction.

Includes:
* Screens (pages)
* Widgets
* UI components
* **Animations** (Splash & Page transitions)

---

### 3.4 Data Models Layer (Entities)

Responsible for defining the data structure used throughout the app.

Includes:
* `UserModel`
* `ChatModel`
* `MessageModel`

Responsibilities:
* Serialization (`fromMap`, `toMap`)
* Ensuring Type Safety

---

### 3.2 State Management Layer

Responsible for managing application state.

Uses:

* Provider
* ChangeNotifier

Responsibilities:

* Handle UI state
* Notify UI updates
* Manage business logic flow

Examples:

* AuthProvider
* ChatProvider
* UserProvider
* ThemeProvider
* LanguageProvider

---

### 3.3 Data Layer

Responsible for data handling and external services.

Includes:

* Firebase services
* Repositories

Responsibilities:

* Communicate with Firebase
* Handle data operations
* Abstract data sources

Examples:

* AuthService
* ChatService
* UserService
* NotificationService

---

## 4. Folder Structure

lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   ├── localization/
│   └── utils/
│
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   ├── provider/
│   │   └── data/
│   │
│   ├── chat/
│   │   ├── presentation/
│   │   ├── provider/
│   │   └── data/
│   │
│   ├── user/
│   │   ├── presentation/
│   │   ├── provider/
│   │   └── data/
│   │
│   ├── profile/
│   └── settings/
│
├── shared/
│   ├── widgets/
│   └── services/
│
└── main.dart

---

## 5. Data Flow

User Action → UI (Screen)
→ Provider (State Management)
→ Service (Firebase)
→ Firestore / Auth / FCM
→ Response back to Provider
→ UI updates

---

## 6. State Management Strategy

* Each feature has its own Provider
* Providers are injected using MultiProvider
* UI listens using Consumer / context.watch()

---

## 7. Firebase Integration

### Authentication

* Firebase Auth for login/register

### Firestore

* Users collection
* Chats collection
* Messages subcollection

### Storage

* Profile image upload

### FCM

* Push notifications

---

## 8. Design Principles

* Separation of Concerns
* Single Responsibility
* Reusability
* Scalability
* Clean code structure

---

## 9. Rules

* No direct Firebase calls from UI
* All logic must pass through Provider
* Services handle external communication only
* Keep widgets stateless when possible
* **Use constructor-based Dependency Injection for Services into Providers**
* **Always use Data Models instead of raw Maps from Firestore**

---

## 10. Notes

* Architecture is designed to be simple but scalable
* Avoid unnecessary complexity
* Focus on clean structure and readability

---
