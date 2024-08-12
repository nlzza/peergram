import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_theme.dart';
import '../controllers/chat_controller.dart';
import '../core/date_time_ext.dart';
import '../entities/image_message.dart';
import '../entities/text_message.dart';
import 'chat_status_circle.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final friend = controller.friend;
    final lastMessage = controller.lastMessage;
    final ageDateTime = controller.lastMessage.timestamp;
    final unread = controller.unreadCount;

    String lastMessageStr = '';
    final fromYou = lastMessage.uid == controller.user.uid;
    final prefix = fromYou ? 'You: ' : '';
    if (lastMessage is TextMessage && lastMessage.text.isNotEmpty) {
      lastMessageStr = '$prefix${lastMessage.text}';
    } else if (lastMessage is ImageMessage) {
      lastMessageStr = '${prefix}Image';
    }

    return ListTile(
      tileColor: unread > 0 ? AppTheme.primaryColor.withOpacity(0.3) : null,
      onTap: controller.openChat,
      leading: ChatStatusCircle(
        status: controller.status,
        child: Hero(
          tag: friend.uid,
          child: CircleAvatar(
            backgroundImage: NetworkImage(friend.imageUrl),
          ),
        ),
      ),
      title: Text(friend.name),
      subtitle: Text(lastMessageStr.isEmpty ? 'Tap to chat' : lastMessageStr),
      trailing: unread > 0
          ? CircleAvatar(
              radius: 15,
              foregroundColor: Colors.white,
              backgroundColor: AppTheme.primaryColor,
              child: Text(unread.toString()),
            )
          : lastMessageStr.isNotEmpty
              ? Text(
                  ageDateTime.ageStr,
                  style: const TextStyle(fontSize: 16),
                )
              : null,
    );
  }
}
