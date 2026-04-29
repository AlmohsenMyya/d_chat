import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String text;
  final String type;
  final DateTime createdAt;
  final bool read;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.type,
    required this.createdAt,
    required this.read,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      messageId: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] ?? 'text',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: map['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'read': read,
    };
  }
}
