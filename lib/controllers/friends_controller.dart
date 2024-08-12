import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../core/navigation_service.dart';
import '../core/overlay_service.dart';
import '../core/utils.dart';
import '../entities/user_data.dart';
import 'chat_controller.dart';
import 'user_repo.dart';

typedef FriendList = List<UserData>;
typedef FriendChats = Map<String, ChatController>;

class FriendController extends ChangeNotifier {
  bool firstTime = true;
  FriendList friends = [];
  FriendChats chats = {};

  late UserData user;
  late ServerSocket server;

  StreamSubscription<Socket>? clientStream;
  StreamSubscription<List<UserData>>? friendsStream;

  final repo = UserRepo.instance;
  final overlay = OverlayService.instance;
  final nav = NavigationService.instance;

  Future<FriendList> searchPeers(String email) async {
    FriendList results = [];
    await handleErrors(
      () async {
        results = await repo.fetchByEmail(email);
        final alreadyFriends = [this.user, ...this.friends];
        results.removeWhere(alreadyFriends.contains);
      },
    );
    return results;
  }

  void addFriend(UserData friend) {
    handleErrors(
      () async {
        nav.showLoadingIndicator();
        await repo.addFriend(this.user.uid, friend.uid);
        chats[friend.uid]?.reconnect();
        notifyListeners();
        nav.pop();
        nav.pop();
      },
    );
  }

  void initController(UserData currentUser) async {
    handleErrors(
      () async {
        this.user = currentUser;
        friendsStream?.cancel();
        friendsStream = repo.friendsStream(user.uid).listen((_) {});
        friendsStream!.onData(updateFriends);
        friendsStream!.onError(overlay.catchError);
        startListening();
      },
    );
  }

  void updateFriends(FriendList friends) {
    for (final friend in friends) {
      final exists = chats.containsKey(friend.uid);
      if (exists) continue;
      chats[friend.uid] = ChatController.disconnected(
        user: this.user,
        friend: friend,
        updateList: notifyListeners,
      );
      if (firstTime) chats[friend.uid]!.reconnect();
    }
    firstTime = false;
    this.friends = friends;
    notifyListeners();
  }

  void startListening() {
    handleErrors(
      () async {
        server = await ServerSocket.bind(user.ipAddress, AppConstants.port, shared: true);
        clientStream?.cancel();
        clientStream = server.listen((_) {});
        clientStream!.onData(listenMessages);
        clientStream!.onError(overlay.catchError);
        clientStream!.onDone(clean);
      },
    );
  }

  void listenMessages(Socket socket) async {
    ByteStream messageStream = const Stream<Uint8List>.empty().listen((_) {});
    handleErrors(
      () async {
        messageStream = socket.listen((_) {});
        messageStream.onData(
          (bytes) {
            final userId = String.fromCharCodes(bytes);
            chats[userId]?.initChat(socket, messageStream);
          },
        );
      },
      onError: () {
        messageStream.cancel();
        socket.close();
        socket.destroy();
      },
    );
  }

  void clean() {
    clientStream?.cancel();
    friendsStream?.cancel();
    server.close();
  }

  @override
  void dispose() {
    super.dispose();
    clean();
  }
}
