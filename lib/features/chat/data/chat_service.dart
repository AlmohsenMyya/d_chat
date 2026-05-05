import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'message_model.dart';
import '../../user/data/user_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/constants/app_config.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService;
  final NotificationService _notificationService;

  ChatService(this._userService, this._notificationService);

  // Cloudinary Configuration
  final String _cloudinaryUrl = AppConfig.cloudinaryUrl;
  final String _uploadPreset = AppConfig.cloudinaryUploadPreset;

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
    final senderId = message.senderId;
    final receiverId =
    participants.firstWhere((id) => id != senderId);

    // 2. Update parent chat document for the chat list view
    final chatRef = _firestore.collection('chats').doc(chatId);
// 🔥 نقرأ القيم الحالية (حتى لا نخرب العدّاد)
    final chatDoc = await chatRef.get();
    final currentUnread = Map<String, dynamic>.from(
        chatDoc.data()?['unreadCounts'] ?? {});

// 👇 نحسب القيم الجديدة
    final updatedUnread = {
      ...currentUnread,
      senderId: 0, // المرسل دائماً صفر
      receiverId: (currentUnread[receiverId] ?? 0) + 1, // زيادة للمستلم
    };

    batch.set(chatRef, {
      'participants': participants,
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'chatId': chatId,
      'unreadCounts': updatedUnread, // 🔥 المهم
    }, SetOptions(merge: true));
    await batch.commit();

    // 3. Trigger Push Notification to recipient
    _triggerNotification(message, participants);
  }

  Future<void> _triggerNotification(MessageModel message, List<String> participants) async {
    try {
      final recipientId = participants.firstWhere((id) => id != message.senderId);

      final senderDoc = await _firestore.collection('users').doc(message.senderId).get();
      final recipientDoc = await _userService.getUserById(recipientId);

      if (recipientDoc != null && recipientDoc.fcmToken != null) {
        final senderName = senderDoc.data()?['name'] ?? "New Message";
        
        await _notificationService.sendPushNotification(
          recipientToken: recipientDoc.fcmToken!,
          title: senderName,
          body: message.type == 'image' ? "Sent an image" : message.text,
          data: {
            "chatId": getChatId(message.senderId, recipientId),
            "senderId": message.senderId,
          },
        );
      }
    } catch (e) {
      debugPrint("Notification Trigger Error: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getChatsStream(String currentUserId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // 👇 أضف chatId (مهم)
        data['chatId'] = doc.id;

        // 👇 unreadCounts
        final unreadCounts =
        Map<String, dynamic>.from(data['unreadCounts'] ?? {});

        // 👇 احسب unreadCount للمستخدم الحالي
        final unreadCount = unreadCounts[currentUserId] ?? 0;

        data['unreadCount'] = unreadCount;

        return data;
      }).toList();
    });
  }
  Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    final chatRef = _firestore.collection('chats').doc(chatId);

    // 🔥 صفّر العداد فوراً
    await chatRef.update({
      'unreadCounts.$currentUserId': 0,
    });

    // 🔽 بعدها (اختياري) علّم الرسائل مقروءة
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();

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
