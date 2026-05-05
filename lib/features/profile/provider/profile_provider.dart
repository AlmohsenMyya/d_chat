import 'dart:io';
import 'package:flutter/material.dart';
import '../../user/data/user_service.dart';
import '../../../shared/services/media_service.dart';
import '../../auth/data/auth_service.dart';

class ProfileProvider with ChangeNotifier {
  final UserService _userService;
  final MediaService _mediaService;
  final AuthService _authService;

  bool _isLoading = false;
  File? _pickedImage;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  File? get pickedImage => _pickedImage;
  String? get errorMessage => _errorMessage;

  ProfileProvider(this._userService, this._mediaService, this._authService);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final image = await _mediaService.pickImageFromGallery();
    if (image != null) {
      _pickedImage = image;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String uid, String name) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      String? photoUrl;
      if (_pickedImage != null) {
        photoUrl = await _authService.uploadProfileImage(_pickedImage!);
      }

      await _userService.updateUserProfile(uid, name: name, photoUrl: photoUrl);
      
      // Update Firebase Auth metadata
      final user = _authService.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
      }

      _pickedImage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
