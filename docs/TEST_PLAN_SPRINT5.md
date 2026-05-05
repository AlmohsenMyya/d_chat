# Comprehensive Test & Verification Plan (Sprint 5 + Full App)

This document provides a systematic guide to verify the functionality, stability, and architectural integrity of D-chat after the completion of Sprint 5.

---

## 1. Sprint 5 Specific Features (The Advanced Core)

### A. Real-Time Presence & Reliability
*   **Scenario 1: Manual Logout**
    *   **Action**: Log out from the Home screen.
    *   **Verify**: Check Firestore/another device. User status must flip to `Offline` immediately.
*   **Scenario 2: App Kill (Ghost Online Test)**
    *   **Action**: While online, force close (Kill Task) the app or disconnect Wi-Fi.
    *   **Verify**: Within seconds, the user's status in Firestore (monitored by Realtime DB `.onDisconnect`) must automatically flip to `false`.
*   **Scenario 3: Re-entry**
    *   **Action**: Open the app again.
    *   **Verify**: Status must flip back to `Online` without manual intervention.

### B. Read Receipts (The Tick System)
*   **Scenario 1: Message Delivery**
    *   **Action**: Send a message to User B.
    *   **Verify**: You should see a **Single Grey Tick**.
*   **Scenario 2: Message Read**
    *   **Action**: Open User B's device and enter the chat.
    *   **Verify**: On the sender's device, the tick must turn into a **Blue Double Tick** instantly.

### C. Cloudinary Storage Migration
*   **Scenario 1: Profile Image**
    *   **Action**: Register a new account with a profile picture.
    *   **Verify**: Go to Cloudinary Dashboard or inspect Firestore `users` collection. The `photoUrl` must point to `cloudinary.com`.
*   **Scenario 2: Chat Image**
    *   **Action**: Send an image in a chat.
    *   **Verify**: The `imageUrl` in the `messages` sub-collection must be a Cloudinary URL.
*   **Scenario 3: UI Rendering**
    *   **Verify**: Image appears in the `ChatBubble` with a loading shimmer and correctly rounded corners.

### D. UI Polish (Shimmer & UX)
*   **Scenario 1: Perceived Performance**
    *   **Action**: Launch the app (or trigger a slow network).
    *   **Verify**: You should see **Skeleton Loaders** (Shimmer) in the Chat list and User list instead of a blank screen or a simple spinner.

---

## 2. Full App Regression (The Baseline)

### A. Authentication & Session
*   **Hot Restart Test**: Perform a Hot Restart while logged in.
    *   **Pass**: App shows Splash -> waits for `isInitialized` -> Lands on **Home** (NOT Onboarding).
*   **Navigation Stack**: In Home screen, try to use the system "Back" button.
    *   **Pass**: App should close or stay on Home (No back arrow in AppBar).

### B. Search & Discovery
*   **Search**: Type a name in the `UsersScreen`.
    *   **Pass**: List filters instantly. Searching "Ar" should find "Arabic" names if they exist.
*   **Exclusion**: Verify you do NOT see your own name in the Users list.

### C. Architecture Compliance (Visual Audit)
*   **Dumb UI**: Check if any screen file contains `FirebaseFirestore` or `pickImage`.
    *   **Pass**: All logic must reside in `lib/features/*/provider/` or `lib/features/*/data/`.

---

## 3. Automation Verification
*   **Command**: `flutter test`
*   **Goal**: Ensure 100% pass rate. (Current: **100% Pass**).

---
**Verification Signature:**
- [ ] Presence Verified
- [ ] Read Receipts Verified
- [ ] Cloudinary Verified
- [ ] Session Persistence Verified
- [ ] Architecture Verified
