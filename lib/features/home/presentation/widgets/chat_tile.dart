import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../user/data/user_model.dart';
import '../../../user/data/user_service.dart';

class ChatTile extends StatelessWidget {
  final Map<String, dynamic> chatData;
  final String currentUserId;
  final Function(UserModel) onTap;

  const ChatTile({
    super.key,
    required this.chatData,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final targetId =
    (chatData['participants'] as List).firstWhere((id) => id != currentUserId);

    final userService = context.read<UserService>();

    // ✅ نعتمد فقط على القيمة الجاهزة
    final int unreadCount = chatData['unreadCount'] ?? 0;
    final bool hasUnread = unreadCount > 0;

    return StreamBuilder<UserModel?>(
      stream: userService.getUserStream(targetId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final user = snapshot.data!;
        final lastMessage = chatData['lastMessage'] ?? "";
        final lastTime = chatData['lastMessageTime'] != null
            ? (chatData['lastMessageTime'] as dynamic).toDate()
            : DateTime.now();

        return ListTile(
          onTap: () => onTap(user),

          // 👤 الصورة + الحالة
          leading: Stack(
            children: [
              Hero(
                tag: 'avatar_${user.uid}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ),
              if (user.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          // 🧑 الاسم
          title: Text(
            user.name,
            style: TextStyle(
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          // 💬 الرسالة
          subtitle: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: hasUnread ? Colors.black : Colors.grey,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          // ⏰ الوقت + 🔴 badge
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('hh:mm a').format(lastTime),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (hasUnread)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}