import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cloudinary Configuration
  final String _cloudinaryUrl = "https://api.cloudinary.com/v1_1/dyvsf3nd8/image/upload";
  final String _uploadPreset = "unsigned_preset";

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

  // Stream of all chats where the current user is a participant
  Stream<List<Map<String, dynamic>>> getChatsStream(String currentUserId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Mark all messages from the other user as read
  Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Mark a single message as read
  Future<void> markAsRead(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  // Upload image to Cloudinary using REST API (Unsigned)
  Future<String> uploadChatImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(_cloudinaryUrl),
      );

      request.fields['upload_preset'] = _uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var responseData = await response.stream.toBytes();
        var jsonResponse = jsonDecode(utf8.decode(responseData));

        return jsonResponse['secure_url'] as String;
      } else {
        throw Exception("Cloudinary upload failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Cloudinary Upload Error: $e");
      rethrow;
    }
  }
}
