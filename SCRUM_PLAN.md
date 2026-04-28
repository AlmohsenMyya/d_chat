# D-chat — Scrum Plan

---

## 1. Overview

This project follows Agile methodology using Scrum.
Development is divided into Sprints, each delivering a working increment of the system.

---

## 2. Product Backlog

### Core Features

* User Registration & Login
* User List & Search
* Real-time Messaging
* Chat Management
* Online / Offline Status
* Push Notifications (FCM)
* Profile Management (Image Upload)
* Settings (Language & Theme)

---

### UI Screens

* Splash Screen
* Onboarding (3 screens)
* Login Screen
* Register Screen
* Home Screen (Chats)
* Users Screen
* Chat Screen
* Settings Screen
* Profile Screen

---

## 3. Sprint Plan

---

### 🟣 Sprint 0 — Initialization & Architecture

**Goal:** Prepare project foundation

**Tasks:**

* Setup Flutter project
* Setup Firebase (Auth + Firestore + FCM)
* Create project folder structure (layers)
* Setup Provider (state management)
* Setup routing/navigation
* Create base services (AuthService, ChatService)

**Deliverable:**
Project ready for development

---

### 🟢 Sprint 1 — Core System Setup (Theme & Localization)

**Goal:** Build dynamic system foundation

**Tasks:**

* Implement Light/Dark Theme system
* Implement Localization (Arabic / English)
* Create theme provider
* Create language provider
* Build Splash Screen
* Build base reusable UI components

**Deliverable:**
App supports dynamic theme & language

---

### 🟡 Sprint 2 — Authentication

**Goal:** Enable user access

**Tasks:**

* Build Login UI
* Build Register UI
* Implement Firebase Authentication
* Add form validation
* Handle errors & loading states
* Implement session persistence

**Deliverable:**
User can register and login successfully

---

### 🟠 Sprint 3 — User Management

**Goal:** Display and select users

**Tasks:**

* Build Home Screen (Chats list)
* Build Users Screen
* Fetch users from Firestore
* Implement search functionality
* Navigate to Chat Screen

**Deliverable:**
User can view and select other users

---

### 🔵 Sprint 4 — Messaging System

**Goal:** Implement chat functionality

**Tasks:**

* Design Firestore chat structure
* Build Chat Screen UI
* Send messages
* Receive messages (real-time)
* Display messages (chat bubbles)
* Auto-scroll to latest message

**Deliverable:**
Real-time chat working

---

### 🟤 Sprint 5 — Notifications & Online Status

**Goal:** Improve communication experience

**Tasks:**

* Integrate Firebase Cloud Messaging (FCM)
* Send push notifications
* Handle notification navigation
* Implement online/offline status
* Update lastSeen field

**Deliverable:**
Notifications + presence system working

---

### 🟣 Sprint 6 — Profile & Settings

**Goal:** User personalization

**Tasks:**

* Build Profile Screen
* Upload profile image (Firebase Storage)
* Update user data
* Build Settings Screen
* Implement language switching
* Implement theme switching

**Deliverable:**
User can manage profile and settings

---

### ⚫ Sprint 7 — UI Polish & Finalization

**Goal:** Final improvements

**Tasks:**

* Improve UI consistency
* Fix bugs
* Optimize performance
* Test all features
* Final cleanup

**Deliverable:**
Stable and complete application

---

## 4. Definition of Done (DoD)

A feature is considered complete when:

* Fully implemented
* Tested without errors
* Integrated with Firebase
* Matches UI design
* Code is clean and structured

---

## 5. Development Rules

* Follow layered architecture
* Use Provider for state management
* Keep code modular and reusable
* Avoid adding features outside SRS
* Implement feature by feature (no multitasking)

---

## 6. Notes

* Each Sprint must deliver a working feature
* Always test before moving to next Sprint
* Avoid over-engineering

---
