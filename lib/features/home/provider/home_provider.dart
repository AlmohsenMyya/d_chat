import 'dart:async';
import 'package:flutter/material.dart';
import '../../chat/data/chat_service.dart';
import '../../user/data/user_service.dart';
import '../../user/data/user_model.dart';
import '../../../core/utils/navigation_service.dart';
import '../../../core/utils/app_routes.dart';

class HomeProvider with ChangeNotifier {
  final ChatService _chatService;
  final UserService _userService;
  final NavigationService _navigationService;
  final String _currentUserId;

  StreamSubscription? _chatSubscription;
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get chats => _chats;
  bool get isLoading => _isLoading;

  HomeProvider(
    this._chatService,
    this._userService,
    this._navigationService,
    this._currentUserId,
  ) {
    _initChatsStream();
  }

  void _initChatsStream() {
    _chatSubscription?.cancel();
    _chatSubscription = _chatService.getChatsStream(_currentUserId).listen((chatsData) {
      _chats = chatsData;
      _isLoading = false;
      notifyListeners();
    });
  }

  // Helper to get the other participant's user info
  // In a real app, we might want to fetch these in batch or cache them
  Future<UserModel?> getTargetUser(List<dynamic> participants) async {
    final targetId = participants.firstWhere((id) => id != _currentUserId);
    // Note: We'll implement a simple fetch in UserService for this later if needed, 
    // or use the already fetched users from UserProvider if globally cached.
    // For now, we'll assume the chat contains basic target info or fetch it once.
    return null; // Placeholder for UI to handle
  }

  void openChat(UserModel user) {
    _navigationService.navigateTo(AppRoutes.chat, arguments: user);
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }
}
