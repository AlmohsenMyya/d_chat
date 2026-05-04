import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../data/auth_service.dart';
import '../../../core/services/presence_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/navigation_service.dart';
import '../../../core/utils/app_routes.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final NavigationService _navigationService;
  final PresenceService? _presenceService;
  final NotificationService? _notificationService;
  
  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  File? _pickedImage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;
  File? get pickedImage => _pickedImage;

  AuthProvider(this._authService, this._navigationService, [this._presenceService, this._notificationService]) {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      _isInitialized = true;
      if (user != null) {
        _presenceService?.configurePresence(user.uid);
        _setupNotifications(user.uid);
      }
      notifyListeners();
    });
  }

  Future<void> _setupNotifications(String uid) async {
    if (_notificationService == null) return;
    await _notificationService!.initialize();
    final token = await _notificationService!.getToken();
    await _authService.updateFCMToken(uid, token);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signIn(email, password);
      _navigationService.pushAndRemoveUntil(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    _setLoading(true);
    try {
      await _authService.signUp(email, password, name, imageFile: _pickedImage);
      _navigationService.pushAndRemoveUntil(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'no_user_found';
      case 'wrong-password':
        return 'wrong_password';
      case 'email-already-in-use':
        return 'email_in_use';
      case 'invalid-email':
        return 'invalid_email';
      case 'network-request-failed':
        return 'network_error';
      default:
        return 'auth_failed';
    }
  }

  Future<void> signOut() async {
    try {
      if (_user != null && _presenceService != null) {
        await _presenceService!.setOffline(_user!.uid);
      }
      await _authService.signOut();
      _navigationService.replaceWith(AppRoutes.login);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void clearImageData() {
    _pickedImage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
