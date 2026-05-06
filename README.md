# D-chat — Engineering a Real-Time System with Clean Architecture

<p align="center">
  <img src="assets/logo.png" alt="D-chat Logo" width="120"/>
</p>

D-chat is a real-time messaging application developed as a structured software engineering project.

The goal is not to build a feature-rich chat app,
but to demonstrate **how a scalable, maintainable system is designed, implemented, and evolved** using professional engineering practices.

---

## 🧠 Engineering Focus

This project prioritizes:

* Architectural clarity over feature quantity
* System behavior over UI complexity
* Long-term maintainability over short-term implementation

> The emphasis is on *how the system is built*, not just *what it does*.

---

## 🏗️ System Architecture

The application follows a strict layered architecture:

```id="arch1"
Presentation (UI)
    ↓
State Management (Provider)
    ↓
Business Logic (Services)
    ↓
External Systems (Firebase / Cloudinary)
```

### Core Principles

* **Separation of Concerns**
* **Logic-Free UI (Dumb UI)**
* **Dependency Injection (constructor-based)**
* **Service Abstraction for external integrations**
* **Strongly-typed data models**

Reference:

---

## ⚙️ Incremental System Evolution

The system was developed using Scrum methodology , with each sprint introducing a new architectural layer:

### Sprint 1–2: Foundation & Authentication

* Project structure and layered architecture
* Theme and localization system
* Firebase Authentication with session persistence

---

### Sprint 3: User Layer

* Real-time user discovery
* Search and filtering logic in Provider
* Clean navigation flow and session handling

---

### Sprint 4: Communication Layer

* Real-time messaging via Firestore streams
* Deterministic chat ID generation
* Atomic batch writes for consistency

---

### Sprint 5: System Behavior Layer

* Reliable presence system (Realtime Database + Firestore)
* Read receipts (message state tracking)
* Media handling via Cloudinary
* Direct FCM v1 notifications without Cloud Functions

---

### Sprint 6: Personalization Layer

* Profile management (name & image)
* Theme switching (Light/Dark)
* Localization (Arabic / English)
* Centralized settings system

---

### Sprint 7: Finalization & Optimization

* UI consistency and design alignment
* Performance improvements and widget optimization
* Error handling and connectivity awareness

---

## 🔬 Key Engineering Solutions

### Reliable Presence System

A hybrid approach using Firebase Realtime Database `.onDisconnect()` ensures accurate online/offline state even during crashes or network loss.

---

### Client-Side FCM v1 Implementation

Push notifications are triggered directly from the client using OAuth2 tokens, eliminating the need for Cloud Functions.

Reference:

---

### Storage Abstraction

Media handling was migrated from Firebase Storage to Cloudinary without affecting UI or Providers, validating the decoupled architecture.

---

### Strict Layer Enforcement

* No direct Firebase access in UI
* Providers manage all business logic
* Services encapsulate external communication

---

## 🧪 Verification & Quality Assurance

The system was validated through structured test scenarios:

* Presence reliability under network failure
* Read receipt consistency
* Media upload and rendering
* Session persistence
* Architectural compliance audit

Reference:

---

## 📊 System Capabilities

| Domain        | Capability                           |
| ------------- | ------------------------------------ |
| Messaging     | Real-time 1-to-1 chat                |
| Presence      | Live online/offline tracking         |
| Notifications | Direct FCM v1 push                   |
| Media         | Cloudinary-based storage             |
| State         | Provider architecture                |
| UX            | Shimmer loading + smooth transitions |

Reference:

---

## 🛠️ Tech Stack

* Flutter (Material 3)
* Firebase (Authentication, Firestore, RTDB, FCM)
* Cloudinary (Media Storage)
* Provider (State Management)

---

## 🔐 Configuration & Security

* Sensitive keys externalized via `.env`
* Centralized configuration management
* Clear separation between code and secrets

Reference:

---

## 🎯 What This Project Demonstrates

This project highlights:

* Clean architecture implementation in a real-world scenario
* Designing real-time systems with consistency and reliability
* Managing complexity through layered abstraction
* Applying Agile (Scrum) in structured development
* Building systems ready for scaling and maintenance

---

## 🚀 Future Extensions

* End-to-End Encryption (E2EE)
* Group messaging
* Voice & video communication
* Cross-platform (Web/Desktop)

---

## 👨‍💻 Author

**Almohsen Myya**
Software Engineer — Mobile Systems

---

## 📌 Final Remark

D-chat is intentionally minimal in features.

Its value lies in demonstrating how a real-time system can be **designed, structured, and implemented correctly from the ground up**.

---
