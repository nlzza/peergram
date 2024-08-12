import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/navigation_service.dart';
import '../core/overlay_service.dart';
import '../core/utils.dart';
import '../entities/chat_status.dart';
import '../entities/image_message.dart';
import '../entities/message_data.dart';
import '../entities/text_message.dart';
import '../entities/user_data.dart';
import '../screens/chat_screen.dart';

typedef ByteStream = StreamSubscription<Uint8List>;

class ChatController extends ValueNotifier<List<MessageData>> {
  int unreadCount = 0;
  bool isOpened = false;
  ChatStatus status = ChatStatus.Disconnected;
  MessageData lastMessage = TextMessage(uid: '', text: '', timestamp: DateTime.now());

  late Socket socket;
  late ByteStream messages;
  final UserData user;
  final UserData friend;
  final VoidCallback updateList;

  final nav = NavigationService.instance;
  final overlay = OverlayService.instance;

  ChatController.connected({
    required this.socket,
    required this.user,
    required this.friend,
    required this.messages,
    required this.updateList,
  }) : super([]);

  ChatController.disconnected({
    required this.user,
    required this.friend,
    required this.updateList,
  }) : super([]);

  void initChat(Socket endpoint, ByteStream stream) {
    handleErrors(() async {
      socket = endpoint;
      messages = stream;
      messages.onData(receive);
      messages.onDone(closeConnection);
      messages.onError(overlay.catchError);
      connectStatus();
    }, onError: () {
      disconnectStatus();
      endpoint.close();
      stream.cancel();
    });
  }

  void reconnect() async {
    try {
      await closeConnection();
      connectingStatus();
      socket = await Socket.connect(
        friend.ipAddress,
        AppConstants.port,
        timeout: AppConstants.timeout,
      );
      socket.add(user.uid.codeUnits);
      initChat(socket, socket.listen((_) {}));
      connectStatus();
    } catch (e) {
      disconnectStatus();
    }
  }

  void openChat() {
    isOpened = true;
    nav.to(
      ChangeNotifierProvider.value(
        value: this,
        child: const ChatScreen(),
      ),
    );
  }

  void closeChat() {
    isOpened = false;
    unreadCount = 0;
    notifyListeners();
    nav.pop();
  }

  void receive(Uint8List bytes) async {
    final json = String.fromCharCodes(bytes);
    final message = MessageData.fromJson(json);
    value.insert(0, message);
    lastMessage = message;
    if (!isOpened) unreadCount++;
    notifyListeners();
    updateList();
  }

  void sendText(String text) {
    handleErrors(
      () async {
        final message = TextMessage(
          uid: user.uid,
          text: text,
          timestamp: DateTime.now(),
        );
        final data = message.toMap();
        socket.add(jsonEncode(data).codeUnits);
        value.insert(0, message);
        lastMessage = message;
        notifyListeners();
        updateList();
      },
    );
  }

  void sendImage(File imageFile) {
    handleErrors(
      () async {
        final timestamp = DateTime.now();
        final task = await FirebaseStorage.instance
            .ref('images') //
            .child('${timestamp.millisecondsSinceEpoch}')
            .putFile(imageFile);
        final imageUrl = await task.ref.getDownloadURL();

        final message = ImageMessage(
          uid: user.uid,
          imageUrl: imageUrl,
          timestamp: timestamp,
        );
        final data = message.toMap();
        socket.add(jsonEncode(data).codeUnits);
        value.insert(0, message);
        lastMessage = message;
        notifyListeners();
        updateList();
      },
    );
  }

  void disconnectStatus() {
    this.status = ChatStatus.Disconnected;
    notifyListeners();
  }

  void connectingStatus() {
    this.status = ChatStatus.Connecting;
    notifyListeners();
  }

  void connectStatus() {
    this.status = ChatStatus.Connected;
    notifyListeners();
  }

  Future<void> closeConnection() async {
    try {
      disconnectStatus();
      await messages.cancel();
      await socket.close();
      socket.destroy();
    } catch (e) {}
  }

  @override
  void dispose() {
    closeConnection();
    super.dispose();
  }
}
