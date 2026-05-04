import 'package:flutter/material.dart';
import '../../../user/data/user_model.dart';

class ChatScreen extends StatelessWidget {
  final UserModel user;

  const ChatScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null ? const Icon(Icons.person, size: 18) : null,
            ),
            const SizedBox(width: 10),
            Text(user.name),
          ],
        ),
      ),
      body: const Center(
        child: Text("Chat Functionality coming in Sprint 4"),
      ),
    );
  }
}
