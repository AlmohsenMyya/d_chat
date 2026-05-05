import 'dart:async';
import 'package:flutter/material.dart';
import '../data/chat_service.dart';
import '../data/message_model.dart';
import '../../../shared/services/media_service.dart';
import '../../../core/utils/navigation_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class ChatProvider with ChangeNotifier {
  final ChatService _chatService;
  final NavigationService _navigationService;
  final MediaService _mediaService;
  final String _currentUserId;
  final String _targetUserId;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();
  Future<void> clearChatNotifications() async {
    try {
      await _localNotifications.cancel(id: _chatId.hashCode);
      debugPrint("🔕 Cleared notifications for chat: $_chatId");
    } catch (e) {
      debugPrint("❌ Error clearing notifications: $e");
    }
  }

  StreamSubscription? _messageSubscription;
  List<MessageModel> _messages = [];
  bool _isLoading = true;
  bool _isUploading = false;
  final String _chatId;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String get chatId => _chatId;
  String get currentUserId => _currentUserId;

  ChatProvider(
    this._chatService,
    this._navigationService,
    this._mediaService,
    this._currentUserId,
    this._targetUserId,
  ) : _chatId = _chatService.getChatId(_currentUserId, _targetUserId) {
    _initMessagesStream();
  }

  void _initMessagesStream() {
    _messageSubscription?.cancel();
    _messageSubscription = _chatService.getMessagesStream(_chatId).listen((messages) {
      _messages = messages;
      _isLoading = false;
      _markAsRead(); // Mark incoming messages as read if we are in the chat
      notifyListeners();
    });
  }

  Future<void> _markAsRead() async {
    try {
      await _chatService.markMessagesAsRead(_chatId, _currentUserId);

      // 🔥 حذف الإشعار عند القراءة
      await clearChatNotifications();

    } catch (e) {
      debugPrint("Error marking messages as read: $e");
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final message = MessageModel(
      senderId: _currentUserId,
      text: text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await _chatService.sendMessage(_chatId, message, [_currentUserId, _targetUserId]);
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  Future<void> sendImageMessage() async {
    final image = await _mediaService.pickImageFromGallery();
    
    if (image == null) return;

    _isUploading = true;
    notifyListeners();

    try {
      final imageUrl = await _chatService.uploadChatImage(image);
      final message = MessageModel(
        senderId: _currentUserId,
        text: "[Image]",
        imageUrl: imageUrl,
        type: 'image',
        createdAt: DateTime.now(),
      );
      await _chatService.sendMessage(_chatId, message, [_currentUserId, _targetUserId]);
    } catch (e) {
      debugPrint("Error uploading/sending image: $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void goBack() {
    _navigationService.goBack();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}
