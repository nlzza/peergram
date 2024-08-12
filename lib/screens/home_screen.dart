import 'package:flutter/material.dart';

import '../app/app_drawer.dart';
import '../app/app_routes.dart';
import '../core/navigation_service.dart';
import '../widgets/chat_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const ChatListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: goToSearch,
          icon: const Icon(Icons.message),
        ),
      ),
    );
  }

  void goToSearch() {
    NavigationService.instance.push(AppRoutes.searchPeers);
  }
}
