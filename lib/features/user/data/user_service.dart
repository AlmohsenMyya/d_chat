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

  // Optional: Server-side search (limited by Firestore capabilities)
  // For better search, we'll implement client-side filtering in the Provider
  Future<List<UserModel>> searchUsersByName(String query, String currentUserId) async {
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
}
