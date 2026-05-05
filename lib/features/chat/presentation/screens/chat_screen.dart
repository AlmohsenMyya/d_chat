import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      HapticFeedback.lightImpact();
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
                Hero(

                  tag: 'avatar_${user.uid}',
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? const Icon(Icons.person, size: 18)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.isOnline
                            ? (loc?.translate('online') ?? "Online")
                            : "${loc?.translate('last_seen') ?? "Last seen"} ${context.read<UserService>().timeAgo(user.lastSeen, loc)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: user.isOnline ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  provider.sendImageMessage();
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!, width: 0.5),
                ),
                child: TextField(
                  controller: _messageController,
                  style:  TextStyle(fontSize: 16 , color: theme.primaryColor),
                  decoration: InputDecoration(
                    hintText: loc?.translate('type_message') ?? "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    fillColor : Colors.grey[100],
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    isDense: true,
                  ),
                  maxLines: 4,
                  minLines: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _handleSend(provider),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
