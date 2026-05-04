import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generates a consistent chatId for two users by sorting their UIDs
  String getChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    return ids.join('_');
  }

  // Stream of messages for a specific chat
  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Send a message
  Future<void> sendMessage(String chatId, MessageModel message, List<String> participants) async {
    final batch = _firestore.batch();

    // 1. Add message to the sub-collection
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();
    
    batch.set(messageRef, message.toMap());

    // 2. Update parent chat document for the chat list view
    final chatRef = _firestore.collection('chats').doc(chatId);
    batch.set(chatRef, {
      'participants': participants,
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'chatId': chatId,
    }, SetOptions(merge: true));

    await batch.commit();
  }

  // Mark message as read
  Future<void> markAsRead(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }
}
