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
    final targetId = (chatData['participants'] as List).firstWhere((id) => id != currentUserId);
    final userService = context.read<UserService>();

    return FutureBuilder<UserModel?>(
      future: userService.getUserById(targetId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        
        final user = snapshot.data!;
        final lastMessage = chatData['lastMessage'] ?? "";
        final lastTime = chatData['lastMessageTime'] != null 
            ? (chatData['lastMessageTime'] as dynamic).toDate() 
            : DateTime.now();

        return ListTile(
          onTap: () => onTap(user),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[300],
                backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
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
          title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            DateFormat('hh:mm a').format(lastTime),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      },
    );
  }
}
