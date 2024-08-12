import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppLogo(),
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Future.delayed(Duration.zero);
    // ignore: use_build_context_synchronously
    final auth = context.read<AuthController>();
    auth.redirectNavigation();
  }
}
