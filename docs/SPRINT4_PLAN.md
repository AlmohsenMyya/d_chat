# Sprint 4 Detailed Implementation Plan: Real-Time Messaging System

This document outlines the step-by-step execution plan for Sprint 4. The goal is to implement a fully functional, real-time 1-on-1 chat system while maintaining 100% architectural compliance.

---

## 1. Data Layer (Models & Services)

### A. Message Model (`lib/features/chat/data/message_model.dart`)
Define a robust model for messages:
- `id`: String (Firestore Document ID)
- `senderId`: String (UID of the sender)
- `text`: String (Message content)
- `type`: String (Default: 'text')
- `createdAt`: DateTime (Mapped from Firestore Timestamp)
- `isRead`: Bool

### B. Chat Service (`lib/features/chat/data/chat_service.dart`)
- `getChatId(String uid1, String uid2)`: Utility to generate a consistent ID by sorting UIDs alphabetically (`uidA_uidB`).
- `getMessagesStream(String chatId)`: Returns `Stream<List<MessageModel>>` sorted by `createdAt` descending.
- `sendMessage(String chatId, MessageModel message)`: 
    1. Writes message to `chats/{chatId}/messages/`.
    2. Updates parent `chat` document with `lastMessage` and `lastMessageTime`.
- `markAsRead(String chatId, String messageId)`: Updates the `isRead` status.

---

## 2. State Management Layer (Provider)

### Chat Provider (`lib/features/chat/provider/chat_provider.dart`)
- **Initialization**: Will use `ChangeNotifierProxyProvider` to receive the `currentUserId` and the `targetUserId`.
- **Logic**:
    - Manage the message stream based on the active `chatId`.
    - Handle message sending (constructing the `MessageModel` and calling the service).
    - Manage the scroll state (auto-scrolling to bottom on new messages).
    - Error handling: Map Firestore errors to localization keys.
- **Navigation**: Use `NavigationService` for any transitions (e.g., leaving the chat).

---

## 3. Presentation Layer (Dumb UI)

### A. Chat Screen (`lib/features/chat/presentation/screens/chat_screen.dart`)
- **Structure**:
    - Custom AppBar: Shows target user's name and online status (from `UserModel`).
    - `ListView.builder` (Reverse: true): For natural message flow.
    - Message Input Area: Integrated with the Provider.
- **Rules**:
    - No direct Firebase calls.
    - Only calls `provider.sendMessage()` on button press.

### B. Chat Components (`lib/shared/widgets/`)
- **`ChatBubble`**: NEW widget.
    - Logic-free styling for "Me" vs "Them".
    - Uses the project's Royal Blue for "Me" and a soft grey for "Them".
    - Displays formatted time.

---

## 4. Implementation Steps

1.  **Step 1: Localization**: Add keys for "Type a message", "Send", "Today", etc.
2.  **Step 2: Service Layer**: Implement `MessageModel` and `ChatService`.
3.  **Step 3: Provider Layer**: Implement `ChatProvider` and register in `main.dart`.
4.  **Step 4: Shared Components**: Build the `ChatBubble`.
5.  **Step 5: Chat Screen**: Assemble the UI and connect to the Provider.
6.  **Step 6: Home Integration**: Update `HomeScreen` to display the actual list of active chats (instead of "No chats yet").

---

## 5. Security & Performance
- **Firestore Rules**: (Future consideration) Ensure users can only read messages where their UID is in the `participants` array.
- **Indexing**: Ensure Firestore indexes are created for `createdAt` sorting.

---
**Status: Locked. Waiting for User Approval to begin Phase 1.**
