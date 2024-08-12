import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/friends_controller.dart';
import '../entities/user_data.dart';

class AddFriendTile extends StatelessWidget {
  const AddFriendTile({super.key, required this.friend});

  final UserData friend;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final controller = context.read<FriendController>();
        controller.addFriend(friend);
      },
      leading: Hero(
        tag: friend.uid,
        child: CircleAvatar(
          backgroundImage: NetworkImage(friend.imageUrl),
        ),
      ),
      title: Text(friend.name),
      subtitle: Text(friend.email),
    );
  }
}
