import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? fcmToken;
  final bool isOnline;
  final bool showLastSeen;
  final bool allowReadReceipts;
  final DateTime lastSeen;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.fcmToken,
    required this.isOnline,
    this.showLastSeen = true,
    this.allowReadReceipts = true,
    required this.lastSeen,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      fcmToken: map['fcmToken'],
      isOnline: map['isOnline'] ?? false,
      showLastSeen: map['showLastSeen'] ?? true,
      allowReadReceipts: map['allowReadReceipts'] ?? true,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'fcmToken': fcmToken,
      'isOnline': isOnline,
      'showLastSeen': showLastSeen,
      'allowReadReceipts': allowReadReceipts,
      'lastSeen': Timestamp.fromDate(lastSeen),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? fcmToken,
    bool? isOnline,
    bool? showLastSeen,
    bool? allowReadReceipts,
    DateTime? lastSeen,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      isOnline: isOnline ?? this.isOnline,
      showLastSeen: showLastSeen ?? this.showLastSeen,
      allowReadReceipts: allowReadReceipts ?? this.allowReadReceipts,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt,
    );
  }
}
