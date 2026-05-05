import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../user/data/user_model.dart';
import '../../../core/constants/app_config.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cloudinary Configuration
  final String _cloudinaryUrl = AppConfig.cloudinaryUrl;
  final String _uploadPreset = AppConfig.cloudinaryUploadPreset;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Upload image to Cloudinary using REST API (Unsigned)
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_cloudinaryUrl));
      
      request.fields['upload_preset'] = _uploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = utf8.decode(responseData);
        var jsonResponse = jsonDecode(responseString);
        return jsonResponse['secure_url'] as String;
      } else {
        throw Exception("Cloudinary upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error uploading profile image to Cloudinary: $e");
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
          photoUrl = await uploadProfileImage(imageFile);
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

  // Update FCM Token
  Future<void> updateFCMToken(String uid, String? token) async {
    if (token == null) return;
    await _firestore.collection('users').doc(uid).update({
      'fcmToken': token,
    });
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
