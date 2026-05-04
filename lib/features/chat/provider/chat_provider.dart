import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/chat_service.dart';
import '../data/message_model.dart';
import '../../../core/utils/navigation_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService;
  final NavigationService _navigationService;
  final String _currentUserId;
  final String _targetUserId;

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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    
    if (pickedFile == null) return;

    _isUploading = true;
    notifyListeners();

    try {
      final imageUrl = await _chatService.uploadChatImage(_chatId, File(pickedFile.path));
      if (imageUrl != null) {
        final message = MessageModel(
          senderId: _currentUserId,
          text: "[Image]",
          imageUrl: imageUrl,
          type: 'image',
          createdAt: DateTime.now(),
        );
        await _chatService.sendMessage(_chatId, message, [_currentUserId, _targetUserId]);
      }
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
