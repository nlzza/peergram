import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_controller.dart';
import '../entities/chat_status.dart';
import '../widgets/chat_body.dart';
import '../widgets/chat_screen_tile.dart';
import '../widgets/send_message_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final status = controller.status;

    return WillPopScope(
      onWillPop: () async {
        controller.closeChat();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          toolbarHeight: kToolbarHeight * 1.2,
          title: const ChatScreenTile(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: ChatBody(),
            ),
            if (status == ChatStatus.Connected) //
              const SendMessageField()
            else
              Container(
                height: kTextTabBarHeight,
                color: status.color,
                alignment: Alignment.center,
                child: Text(
                  status.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
