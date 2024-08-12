import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_controller.dart';
import 'message_bubble.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final targetOffset = 0.0;
  final scrollController = ScrollController();
  late final chat = context.read<ChatController>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: chat,
      builder: (context, messages, _) {
        if (messages.isEmpty) {
          return const Center(
            child: Text(
              'Start a chat',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        moveToBottom();

        return ListView.builder(
          reverse: true,
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (_, i) {
            return MessageBubble(
              message: messages[i],
              fromMe: messages[i].uid == chat.user.uid,
            );
          },
        );
      },
    );
  }

  void moveToBottom() async {
    if (context.mounted == false) return;
    await Future.delayed(Duration.zero);

    if (scrollController.offset == targetOffset) return;
    scrollController.animateTo(
      targetOffset,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
