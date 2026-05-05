import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/chat_bubble.dart';
import '../../../../shared/widgets/shimmer_skeletons.dart';
import '../../../user/data/user_service.dart';
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().clearChatNotifications();
    });
  }

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
        title: StreamBuilder<UserModel?>(
          stream: context.read<UserService>().getUserStream(widget.user.uid),
          builder: (context, snapshot) {
            final user = snapshot.data ?? widget.user;

            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? const Icon(Icons.person, size: 18)
                      : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontSize: 16)),
                    Text(
                      user.isOnline
                          ? (loc?.translate('online') ?? "Online")
                          : "${loc?.translate('last_seen') ?? "Last seen"} ${context.read<UserService>().timeAgo(user.lastSeen, loc)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.isLoading
                ? ListView.builder(
                    reverse: true,
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        ShimmerChatBubble(isMe: index % 2 == 0),
                  )
                : Stack(
                    children: [
                      ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];
                          return ChatBubble(
                            message: message,
                            isMe:
                                message.senderId == chatProvider.currentUserId,
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
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [

            Container(
              decoration: BoxDecoration(
                color:Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.image_outlined,
                  color: Colors.white,
                ),
                onPressed: () => provider.sendImageMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color:Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).primaryColor,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText:
                        loc?.translate('type_message') ?? "Type a message...",
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
