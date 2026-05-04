# Sprint 5 Detailed Implementation Plan: Advanced Communication & Presence

This plan outlines the execution steps for adding professional-grade features to D-chat. The primary focus is on **Real-Time Presence**, **Push Notifications (FCM)**, and **Image Messaging**.

---

## 1. Phase 1: Real-Time Presence (Reliability)
**Objective**: Ensure `isOnline` status is 100% accurate, even during sudden app crashes.

- **Infrastructure**: Add `firebase_database` dependency.
- **Service Layer**: 
    - Create `PresenceService`.
    - Use `.onDisconnect()` in Firebase Realtime Database to trigger a status update to `false` in Firestore when the socket connection is lost.
- **Provider Layer**: Integrate `PresenceService` into `AuthProvider` or create a global `PresenceProvider` that starts monitoring once authenticated.
- **UI Layer**: The existing `green dot` and `online/offline` text in `UsersScreen` and `ChatScreen` will automatically reflect these accurate updates.

---

## 2. Phase 2: Message Status & Read Receipts
**Objective**: Let users know when their messages have been read.

- **Data Layer**: Ensure `isRead` in `MessageModel` is correctly mapped.
- **Service Layer**: Add `ChatService.markMessagesAsRead(String chatId, String currentUserId)`.
- **Provider Layer**: In `ChatProvider`, call the "Mark as Read" logic whenever the user opens the chat or receives a new message while the chat is active.
- **UI Layer**: Add a small "double-check" icon or color change in `ChatBubble` based on the `isRead` field.

---

## 3. Phase 3: Push Notifications (FCM)
**Objective**: Notify users of new messages when the app is in the background.

- **Infrastructure**: Add `firebase_messaging` dependency.
- **Model Layer**: Update `UserModel` to include `fcmToken`.
- **Service Layer**: 
    - Implement `NotificationService` to request permissions and fetch tokens.
    - Update `AuthService` to save the token to Firestore upon login.
- **Trigger Logic**: (Recommendation) For a pure client-side prototype, we can trigger notifications locally, but for production, we'll document how Firebase Cloud Functions would handle the trigger.

---

## 4. Phase 4: Image Messaging
**Objective**: Allow users to share photos in chat.

- **Model Layer**: Update `MessageModel` to support `imageUrl` and `type: 'image'`.
- **Provider Layer**: 
    - Implement `pickChatImage()` in `ChatProvider` (reusing the `ImagePicker` logic).
    - Handle the upload process with a loading state inside the chat.
- **UI Layer**: 
    - Update `ChatBubble` to render images with proper aspect ratios and rounded corners.
    - Add a "Plus" or "Camera" icon to the message input area.

---

## 5. Phase 5: UI Polish (Shimmer & Transitions)
- **Shared Widgets**: Create `ShimmerChatTile` and `ShimmerChatBubble`.
- **Implementation**: Replace standard `CircularProgressIndicator` with these skeletons in `HomeScreen` and `ChatScreen`.

---

## 🛡️ Execution Rules
1. **Dumb UI**: No picking logic or notification listeners in Widgets.
2. **Centralized Logic**: `NavigationService` must be used if a notification click triggers a screen change.
3. **No Over-Engineering**: Use the established `ProxyProvider` patterns.

**Status: Plan Published & Locked. Standing by for Sprint 4 sign-off and approval to start Phase 1.**
