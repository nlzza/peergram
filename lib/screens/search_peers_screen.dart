import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_theme.dart';
import '../controllers/friends_controller.dart';
import '../widgets/add_friend_tile.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  State<SearchFriendsScreen> createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  final textController = TextEditingController();
  late final friendController = context.watch<FriendController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        toolbarHeight: kToolbarHeight * 1.5,
        titleSpacing: 10,
        title: TextField(
          controller: textController,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Search by email',
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: textController,
        builder: (context, value, child) {
          final email = value.text;

          if (email.isEmpty) {
            return const Center(
              child: Text(
                'Search and add your friends\nto chat with them',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }

          return FutureBuilder(
            future: friendController.searchPeers(email),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snap.hasError) {
                return Center(
                  child: Text(
                    snap.error.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.errorColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final users = snap.data!;
              if (users.isEmpty) {
                return const Center(
                  child: Text(
                    'No user found\nfor this email',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.separated(
                itemCount: users.length,
                itemBuilder: (_, i) => AddFriendTile(friend: users[i]),
                separatorBuilder: (_, i) => const SizedBox(height: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
              );
            },
          );
        },
      ),
    );
  }
}
