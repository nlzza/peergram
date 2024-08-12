import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../app/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';
import '../core/overlay_service.dart';

class SendMessageField extends StatefulWidget {
  const SendMessageField({super.key});

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  final textController = TextEditingController();
  late final chat = context.read<ChatController>();
  late final currentUser = context.read<AuthController>().user;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            onPressed: sendFile,
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(Icons.image),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onSubmitted: (x) => sendText(),
                controller: textController,
                autofocus: true,
                textInputAction: TextInputAction.send,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: sendText,
                    color: AppTheme.primaryColor,
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendText() {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    textController.clear();
    try {
      chat.sendText(text);
    } catch (e) {
      OverlayService.instance.catchError(e);
    }
  }

  void sendFile() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;
      chat.sendImage(File(file.path));
    } catch (e) {
      OverlayService.instance.catchError(e);
    }
  }
}
