import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../entities/image_message.dart';
import '../entities/message_data.dart';
import '../entities/text_message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.fromMe,
  });

  final MessageData message;
  final bool fromMe;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.75;
    final color = fromMe ? AppTheme.primaryColor : Colors.grey.shade300;
    final textColor = fromMe ? Colors.white : Colors.black;
    final message = this.message;

    return Row(
      mainAxisAlignment: fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (message is ImageMessage)
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            constraints: BoxConstraints(maxHeight: 300, minHeight: 100, maxWidth: maxWidth),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(message.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              (message as TextMessage).text,
              style: TextStyle(color: textColor),
            ),
          ),
      ],
    );
  }
}
