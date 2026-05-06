import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../user/data/user_service.dart';

class PrivacyProvider with ChangeNotifier {
  final UserService _userService;
  final String? _currentUserId;

  bool _showLastSeen = true;
  bool _allowReadReceipts = true;

  bool get showLastSeen => _showLastSeen;
  bool get allowReadReceipts => _allowReadReceipts;

  PrivacyProvider(this._userService, this._currentUserId) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _showLastSeen = prefs.getBool('show_last_seen') ?? true;
    _allowReadReceipts = prefs.getBool('allow_read_receipts') ?? true;
    notifyListeners();
  }

  Future<void> toggleLastSeen(bool value) async {
    _showLastSeen = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_last_seen', value);

    if (_currentUserId != null) {
      await _userService.updateUserProfile(_currentUserId!, showLastSeen: value);
    }
    notifyListeners();
  }

  Future<void> toggleReadReceipts(bool value) async {
    _allowReadReceipts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allow_read_receipts', value);

    if (_currentUserId != null) {
      await _userService.updateUserProfile(_currentUserId!, allowReadReceipts: value);
    }
    notifyListeners();
  }
}
