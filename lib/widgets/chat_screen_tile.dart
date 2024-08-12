import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_controller.dart';
import '../entities/chat_status.dart';

class ChatScreenTile extends StatelessWidget {
  const ChatScreenTile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final friend = controller.friend;
    final status = controller.status;
    final statusStr = status == ChatStatus.Connected ? 'Online' : 'Offline';

    return ListTile(
      textColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 15,
      leading: Hero(
        tag: friend.uid,
        child: CircleAvatar(
          backgroundImage: NetworkImage(friend.imageUrl),
        ),
      ),
      title: Text(friend.name),
      subtitle: Text(statusStr),
    );
  }
}
