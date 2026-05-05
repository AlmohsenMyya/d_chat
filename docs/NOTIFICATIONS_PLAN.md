# Plan: Client-Side Direct Push Notifications (FCM v1)

## Goal
Implement a free, reliable notification system where the sender's app triggers a push notification to the recipient directly via Firebase Messaging REST API, bypassing the need for paid Cloud Functions.

---

## 1. Technical Strategy (FCM v1 REST API)
Since we cannot use Cloud Functions without the Blaze plan, the sender's device will act as the "Trigger".

**The Flow:**
1.  **User A** sends a message.
2.  **ChatService** successfully writes to Firestore.
3.  **ChatService** fetches **User B's** `fcmToken` from their profile document.
4.  **User A's** app sends a secure HTTP POST request to `fcm.googleapis.com/v1/projects/{project-id}/messages:send`.
5.  **User B** receives the notification.

---

## 2. Implementation Phases

### Phase 1: Security & Credentials (Manual Action Required)
To send messages from the app, we need an **OAuth2 Access Token**.
*   **Challenge**: The old "Server Key" (Legacy) is deprecated and insecure.
*   **Solution**: We will implement a helper or use a service account JSON (securely handled) to generate a short-lived token, or for this prototype, guide you on how to enable the **FCM via HTTP v1** in the Firebase Console.

### Phase 2: Data Layer (Service Update)
- **`NotificationService`**:
    - Add `sendNotification(String receiverToken, String title, String body)`.
    - Handle the JSON payload construction (matching FCM v1 schema).
- **`ChatService`**:
    - Update `sendMessage` to trigger `NotificationService.sendNotification` after the Firestore write is confirmed.

### Phase 3: State Management (Provider Update)
- **`ChatProvider`**:
    - No direct changes needed (it already calls `ChatService.sendMessage`).
    - The logic remains encapsulated in the Service layer to keep the UI "Dumb".

### Phase 4: UI/UX (Feedback)
- Add a toggle in the future "Settings" screen (Sprint 6) to enable/disable notifications (Optional for now).

---

## 3. Risks & Mitigations
*   **Security**: Storing a Service Account key in the app is not recommended for production. 
    *   *Mitigation*: We will use a restricted API key or explain how to secure this if you go to production.
*   **Latency**: Fetching the recipient's token adds a few milliseconds to the "Send" process.
    *   *Mitigation*: We will perform this asynchronously so it doesn't block the UI message appearing.

---

## 4. Required Information
To proceed, I will need you to:
1.  Go to **Firebase Console** -> **Project Settings** -> **Cloud Messaging**.
2.  Ensure **Firebase Cloud Messaging API (V1)** is enabled.
3.  Let me know the **Project ID** (usually found in `google-services.json`).

---
**Status: Planning. Waiting for approval to start Phase 2.**
