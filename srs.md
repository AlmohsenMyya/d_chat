# D-chat — System Specification

---

## 1. Overview

D-chat is a real-time mobile chat application built using Flutter (client) and Firebase (backend).
The system follows a Client–Server architecture and enables instant messaging between users.

---

## 2. Tech Stack

* Flutter (UI / Client)
* Firebase Authentication
* Cloud Firestore
* Firebase Cloud Messaging (FCM)
* Provider (State Management)

---

## 3. Core Features

### 3.1 Authentication

* Email & password registration
* Login / Logout
* Persistent user session

### 3.2 User Management

* Fetch list of users
* Select user to start chat

### 3.3 Messaging

* Send text messages
* Receive messages in real-time
* Store messages in Firestore

### 3.4 Conversations

* One-to-one chat
* Message history per chat

### 3.5 Online Status

* Show user online/offline
* Update status dynamically

### 3.6 Notifications

* Push notifications on new message
* Works in background (FCM)

---

## 4. Non-Functional Requirements

### 4.1 Performance

* Messages must be delivered with minimal delay (real-time)

### 4.2 Usability

* Simple UI
* Smooth navigation

### 4.3 Security

* Only authenticated users can access the system
* Firestore security rules must restrict access

### 4.4 Multi-language

* App supports Arabic and English
* Language can be switched dynamically

### 4.5 Theme

* Support Light Mode and Dark Mode
* User can toggle manually

---

## 5. System Architecture

Client:

* Flutter mobile application

Server:

* Firebase services:

    * Authentication
    * Cloud Firestore
    * Firebase Cloud Messaging

Communication:

* HTTPS + Firebase SDK
* Real-time updates via Firestore listeners

---

## 6. Data Model

### users (collection)

* uid: string
* name: string
* email: string
* photoUrl: string (optional)
* isOnline: boolean
* lastSeen: timestamp
* createdAt: timestamp

---

### chats (collection)

* chatId: string
* participants: array<uid>
* lastMessage: string
* lastMessageTime: timestamp
* createdAt: timestamp

---

### messages (subcollection under chats/{chatId})

* messageId: string
* senderId: string
* text: string
* type: string ("text")
* createdAt: timestamp
* read: boolean

---

### status (collection)

* uid: string
* isOnline: boolean
* lastSeen: timestamp

---

### fcm_tokens (collection)

* uid: string
* token: string
* device: string
* createdAt: timestamp

---

## 7. Key Flows

### 7.1 Send Message Flow

1. User types message
2. App sends message to Firestore (messages collection)
3. Firestore stores message
4. Chat document is updated (lastMessage, lastMessageTime)
5. Receiver gets real-time update via listener
6. FCM sends push notification

---

### 7.2 Receive Message Flow

1. Firestore triggers real-time listener
2. App receives new message
3. Message is displayed in UI
4. Notification is shown if app is in background

---

### 7.3 Authentication Flow

1. User enters email/password
2. Firebase Authentication validates
3. Session is created
4. User data is loaded

---

## 8. Business Rules

* Only authenticated users can send messages
* Users can only access chats they are part of
* Messages must be linked to a valid chatId
* Each chat contains exactly two participants

---

## 9. Design Constraints

* Must use Provider for state management
* Must follow layered architecture
* Must keep code modular and reusable

---

## 10. Architecture Style

The system follows a layered architecture:

### Presentation Layer

* UI screens (Flutter widgets)

### State Management Layer

* Provider (ChangeNotifier)

### Data Layer

* Firebase services (Auth, Firestore, FCM)

---

## 11. Modules

* Auth Module
* User Module
* Chat Module
* Notification Module
* Settings Module (language + theme)

---

## 13. Notes :

* Use this document as the source of truth
* Follow the defined data model strictly
* Do not invent new fields unless necessary
* Keep code clean and modular
* Prefer reusable components
* Ensure separation of concerns

---
