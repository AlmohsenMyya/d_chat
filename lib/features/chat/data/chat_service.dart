import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get list of chats for a user
  Stream<QuerySnapshot> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get messages for a specific chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Send a message
  Future<void> sendMessage(String chatId, Map<String, dynamic> messageData) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update last message in chat document
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': messageData['text'],
      'lastMessageTime': messageData['createdAt'],
    });
  }
}
