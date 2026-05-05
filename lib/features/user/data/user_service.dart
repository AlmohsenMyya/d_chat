import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of all users except the current one
  Stream<List<UserModel>> getUsersStream(String currentUserId) {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList());
  }

  // 🔥 الحل للمشكلة (real-time user)
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!);
    });
  }

  // Get user مرة واحدة (اختياري)
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Search
  Future<List<UserModel>> searchUsersByName(
      String query, String currentUserId) async {
    final snapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .where((user) => user.uid != currentUserId)
        .toList();
  }

  String timeAgo(DateTime? date, dynamic loc) {
    if (date == null) return "";

    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) {
      return loc?.translate('just_now') ?? "just now";
    }

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} ${loc?.translate('minutes_ago') ?? "min ago"}";
    }

    if (diff.inHours < 24) {
      return "${diff.inHours} ${loc?.translate('hours_ago') ?? "h ago"}";
    }

    return "${diff.inDays} ${loc?.translate('days_ago') ?? "d ago"}";
  }
}