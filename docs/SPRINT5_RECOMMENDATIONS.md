# Recommendations & Strategic Design for Sprint 5: Advanced Features

Sprint 5 aims to elevate D-chat from a basic messenger to a professional-grade communication tool. This phase focuses on presence, media, and notification systems.

---

## 1. Presence & Reliability (The "Real-Time" Edge)
### A. Real-Time Presence
- **Issue**: Currently, `isOnline` only updates on manual login/logout.
- **Recommendation**: Implement `firebase_database` (Realtime DB) for the "Presence System".
- **Logic**: Use the `.onDisconnect()` feature to automatically flip `isOnline` to `false` in Firestore when the socket connection breaks (app kill/network loss).

### B. Message Status (Read Receipts)
- **Recommendation**: Implement a "Mark as Read" trigger in the `ChatProvider`.
- **Logic**: When the `ChatScreen` is opened, the Provider should update all messages where `senderId != currentUserId` to `isRead: true`.

---

## 2. Media & Rich Content
### A. Image Messaging
- **Recommendation**: Extend `MessageModel` to include an optional `imageUrl` and a `type` (text/image).
- **Service**: Reuse `AuthService.uploadProfileImage` logic (but directed to a `/chat_media/` folder) to upload and send images.

### B. Shimmer Loading
- **Recommendation**: Replace `CircularProgressIndicator` with Shimmer skeletons for `ChatTile` and `ChatBubble` to improve perceived performance.

---

## 3. Push Notifications (FCM)
### A. Cloud Messaging
- **Recommendation**: Integrate `firebase_messaging`.
- **Logic**: Store the device `fcmToken` in the `UserModel`.
- **Server Side**: Use Firebase Cloud Functions (or a simple local trigger for testing) to send notifications when a new message is added to a chat document.

---

## 4. Architectural Safety for Sprint 5
1.  **Dependency Control**: Only add `firebase_database` and `firebase_messaging` if necessary. Keep the core logic in `ChatService`.
2.  **Model Evolution**: `UserModel` and `MessageModel` should be updated to support `fcmToken` and `imageUrl` respectively.
3.  **UI Decoupling**: Media picking logic should stay in the `Provider`, following the pattern established in Sprint 2 for profile images.

---
**Status: Sprint 5 is a Locked Zone. Execution strictly prohibited until Sprint 4 is fully signed off.**
