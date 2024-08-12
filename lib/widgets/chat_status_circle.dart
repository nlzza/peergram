import 'package:flutter/material.dart';

import '../entities/chat_status.dart';

class ChatStatusCircle extends StatelessWidget {
  const ChatStatusCircle({
    super.key,
    required this.status,
    required this.child,
  });

  final ChatStatus status;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        child,
        CircleAvatar(
          radius: 6,
          backgroundColor: status.color,
        ),
      ],
    );
  }
}
