import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String senderId;
  final String text;
  final String? imageUrl;
  final String type; // 'text' or 'image'
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    this.id,
    required this.senderId,
    required this.text,
    this.imageUrl,
    this.type = 'text',
    required this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      type: map['type'] ?? 'text',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': isRead,
    };
  }
}
