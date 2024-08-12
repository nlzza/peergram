import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/friends_controller.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_peers_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const splash = 'splash';

  static const initial = auth;
  static const auth = 'auth';
  static const home = 'home';
  static const searchPeers = 'searchPeers';

  static Route<dynamic> handleRoutes(RouteSettings route) {
    switch (route.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case auth:
        return MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        );

      case home:
        return MaterialPageRoute(
          builder: (context) {
            final auth = context.read<AuthController>();
            final friend = context.read<FriendController>();
            friend.initController(auth.user);
            return const HomeScreen();
          },
        );

      case searchPeers:
        return MaterialPageRoute(
          builder: (context) => const SearchFriendsScreen(),
        );

      default:
        throw Exception('No routes for ${route.name}');
    }
  }
}
