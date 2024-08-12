import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/friends_controller.dart';
import 'chat_list_tile.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final friendController = context.watch<FriendController>();
    final friends = friendController.friends;
    friends.sort(
      (a, b) {
        final chatA = friendController.chats[a.uid];
        final chatB = friendController.chats[b.uid];
        if (chatA == null || chatB == null) return 0;
        return chatA.lastMessage.compareTo(chatB.lastMessage);
      },
    );

    if (friends.isEmpty) {
      return const Center(
        child: Text(
          'No Friends to chat with?\nGo to search and add some',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(7),
      itemCount: friends.length,
      itemBuilder: (_, i) {
        final friend = friends[i];
        final chatController = friendController.chats[friend.uid];
        if (chatController == null) {
          return const Text('No Chat Controller');
        }
        return ChangeNotifierProvider.value(
          value: chatController,
          child: const ChatListTile(),
        );
      },
    );
  }
}
