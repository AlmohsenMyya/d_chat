import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../user/data/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Upload image to Firebase Storage
  Future<String?> uploadProfileImage(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images').child('$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUp(String email, String password, String name, {File? imageFile}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      if (credential.user != null) {
        String? photoUrl;
        if (imageFile != null) {
          photoUrl = await uploadProfileImage(credential.user!.uid, imageFile);
        }

        final userModel = UserModel(
          uid: credential.user!.uid,
          name: name,
          email: email,
          photoUrl: photoUrl,
          isOnline: true,
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toMap(), SetOptions(merge: true));
            
        // Update Firebase Auth display name and photo
        await credential.user!.updateDisplayName(name);
        if (photoUrl != null) {
          await credential.user!.updatePhotoURL(photoUrl);
        }
      }

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
        
        if (!userDoc.exists) {
          // If document doesn't exist for some reason, create it
          final userModel = UserModel(
            uid: credential.user!.uid,
            name: credential.user!.displayName ?? email.split('@')[0],
            email: email,
            isOnline: true,
            lastSeen: DateTime.now(),
            createdAt: DateTime.now(),
          );
          await _firestore.collection('users').doc(credential.user!.uid).set(userModel.toMap());
        } else {
          // Just update status
          await _firestore.collection('users').doc(credential.user!.uid).update({
            'isOnline': true,
            'lastSeen': FieldValue.serverTimestamp(),
          });
        }
      }
      
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
    await _auth.signOut();
  }
}
