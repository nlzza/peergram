import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_routes.dart';
import 'app/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/friends_controller.dart';
import 'core/constants.dart';
import 'core/navigation_service.dart';
import 'core/overlay_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PeergramApp());
}

class PeergramApp extends StatelessWidget {
  const PeergramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider<FriendController>(
          create: (_) => FriendController(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        theme: AppTheme.theme,
        color: AppTheme.primaryColor,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.handleRoutes,
        navigatorKey: NavigationService.instance.navKey,
        scaffoldMessengerKey: OverlayService.instance.scaffoldKey,
      ),
    );
  }
}
