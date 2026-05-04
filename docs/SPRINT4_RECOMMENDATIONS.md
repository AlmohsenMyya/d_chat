# Recommendations & Strategic Design for Sprint 4: Messaging System

Sprint 4 is the core of D-chat. Based on the robust architecture established in Sprints 1-3, these recommendations ensure a scalable, real-time, and clean implementation of the messaging functionality.

---

## 1. Architectural Integrity (The Red Line)
*   **Logic-Free UI**: The `ChatScreen` must not contain any Firestore listeners or sending logic. It should only render a list provided by a `ChatProvider`.
*   **Service Responsibility**: `ChatService` is the ONLY place where `FirebaseFirestore.instance.collection('chats')` should be called.
*   **Provider Dependency**: `ChatProvider` must be managed as a `ProxyProvider` (similar to `UserProvider`) to ensure it has access to the `currentUserId` and the `selectedUserId`.

---

## 2. Firestore Schema Recommendation
To optimize for read/write costs and speed, the following structure is recommended:

### A. `chats` Collection (The Rooms)
Each document ID should be a unique hash of the two participants' UIDs (e.g., `uid1_uid2` sorted alphabetically) to prevent duplicate rooms.
```json
{
  "participants": ["uid1", "uid2"],
  "lastMessage": "Hello there!",
  "lastMessageTime": "ServerTimestamp",
  "unreadCount_uid1": 0,
  "unreadCount_uid2": 1
}
```

### B. `messages` Sub-collection
Nested inside each chat document for high-speed indexing.
```json
{
  "senderId": "uid1",
  "text": "Hello there!",
  "type": "text", 
  "createdAt": "ServerTimestamp",
  "isRead": false
}
```

---

## 3. Implementation Steps (Phased Approach)

### Phase 1: Data Models & Service
*   Create `MessageModel` to handle mapping Firestore timestamps and IDs.
*   Implement `ChatService.getMessagesStream(String chatId)` for real-time updates.
*   Implement `ChatService.sendMessage(String chatId, MessageModel message)`.

### Phase 2: State Management (Provider)
*   **Pagination**: Recommend implementing a `limit(20)` on the initial stream and loading more as the user scrolls up.
*   **Auto-Scroll**: The Provider should notify the UI to scroll to the bottom when a new message arrives.
*   **Message Grouping**: Logic to group messages by date (e.g., "Today", "Yesterday") should reside in the Provider or a dedicated Utility, NOT the UI.

### Phase 3: Presentation (UI)
*   **Reusable Bubble**: Create a `ChatBubble` widget in `lib/shared/widgets/` that handles different styles for "Sent" vs "Received".
*   **Input Field**: Use `CustomTextField` as a base but extend it to support a "Send" button and multi-line input.
*   **Loading States**: Show Shimmer effects or a customized loader while the stream is initializing.

---

## 4. Performance & UX Tips
*   **Optimistic UI**: (Optional but recommended) Show the message locally in the UI immediately before the Firestore write confirms to make the app feel "instant".
*   **Reverse ListView**: Use `ListView.builder(reverse: true)` to make the chat feel natural and handle keyboard appearance smoothly.
*   **Typing Indicators**: Consider adding a `isTyping` field in the `chats` document for a premium feel (optional).

---
**Warning: Sprint 4 is complex. Do not begin implementation until the Data Model and Service Layer design is fully approved.**
