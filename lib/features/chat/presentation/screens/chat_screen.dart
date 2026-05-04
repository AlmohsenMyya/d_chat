import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/chat_bubble.dart';
import '../../provider/chat_provider.dart';
import '../../../user/data/user_model.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend(ChatProvider provider) {
    if (_messageController.text.trim().isNotEmpty) {
      provider.sendMessage(_messageController.text.trim());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.user.photoUrl != null ? NetworkImage(widget.user.photoUrl!) : null,
              child: widget.user.photoUrl == null ? const Icon(Icons.person, size: 18) : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name, style: const TextStyle(fontSize: 16)),
                Text(
                  widget.user.isOnline ? (loc?.translate('online') ?? "Online") : (loc?.translate('offline') ?? "Offline"),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(10),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];
                          return ChatBubble(
                            message: message,
                            isMe: message.senderId == chatProvider.currentUserId,
                          );
                        },
                      ),
                      if (chatProvider.isUploading)
                        const Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          _buildInputArea(loc, chatProvider),
        ],
      ),
    );
  }

  Widget _buildInputArea(AppLocalizations? loc, ChatProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.image_outlined, color: Theme.of(context).primaryColor),
              onPressed: () => provider.sendImageMessage(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: loc?.translate('type_message') ?? "Type a message...",
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                  minLines: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _handleSend(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
