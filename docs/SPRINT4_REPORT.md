# Sprint 4 Completion Report: Real-Time Messaging System

This report details the implementation of the core messaging engine, completing the primary functional cycle of D-chat.

---

## 1. Accomplishments
- **Real-Time Core**: Established a dual-stream architecture (Messages stream + Chats list stream).
- **Atomic Persistence**: Implemented Firestore Batch Writes to ensure message delivery and chat metadata updates (last message, timestamp) occur simultaneously.
- **Dynamic Contextual Routing**: Developed a routing system that injects specific `ChatProvider` instances per conversation, ensuring clean memory management.
- **Advanced UI Components**: Built high-fidelity, Royal Blue branded components (`ChatBubble`, `ChatTile`, `MessageInput`).

---

## 2. Technical Architecture

### A. Data Layer (Service & Models)
- **`MessageModel`**: Supports text content, sender identification, read receipts, and server-side timestamps.
- **`ChatService`**:
    - `getChatId`: Deterministic ID generation (`uidA_uidB`) prevents duplicate rooms.
    - `sendMessage`: Atomic update of `/chats/{id}/messages/` and `/chats/{id}/`.
    - `getChatsStream`: Real-time filtering of active conversations using `arrayContains`.

### B. State Management (Provider)
- **`ChatProvider`**: 
    - Manages the lifecycle of a single conversation.
    - Handles real-time message synchronization.
- **`HomeProvider`**:
    - Manages the global chat list.
    - Orchestrates the transition from the "Chats" tab to individual conversations.

### C. Presentation Layer (Dumb UI)
- **`ChatScreen`**: Uses `reverse: true` in `ListView` for natural messaging UX. Handles multiline input and real-time status display.
- **`ChatTile`**: Uses `FutureBuilder` to resolve participant identities asynchronously, keeping the chat list lightweight.

---

## 3. Engineering Decisions
- **Consistency**: Used alphabetical sorting for Chat IDs to ensure both participants always land in the same room without server-side logic.
- **Memory Safety**: All `StreamSubscriptions` are manually cancelled in `dispose()` methods.
- **Modularity**: Updated `CustomTextField` to be state-neutral, allowing it to serve both search and messaging inputs.

---
**Status: Sprint 4 Verified. All tests passed.**
