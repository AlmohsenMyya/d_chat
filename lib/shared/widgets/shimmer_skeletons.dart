import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerChatTile extends StatelessWidget {
  const ShimmerChatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: const CircleAvatar(radius: 28, backgroundColor: Colors.white),
        title: Container(
          width: double.infinity,
          height: 12.0,
          color: Colors.white,
        ),
        subtitle: Container(
          width: 150.0,
          height: 10.0,
          margin: const EdgeInsets.only(top: 5),
          color: Colors.white,
        ),
        trailing: Container(
          width: 40.0,
          height: 10.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ShimmerChatBubble extends StatelessWidget {
  final bool isMe;
  const ShimmerChatBubble({super.key, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class ShimmerUserTile extends StatelessWidget {
  const ShimmerUserTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: const CircleAvatar(radius: 25, backgroundColor: Colors.white),
        title: Container(
          width: 100.0,
          height: 12.0,
          color: Colors.white,
        ),
        subtitle: Container(
          width: 60.0,
          height: 10.0,
          margin: const EdgeInsets.only(top: 5),
          color: Colors.white,
        ),
      ),
    );
  }
}
