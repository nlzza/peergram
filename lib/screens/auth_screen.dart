import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/app_logo.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Center(
              child: AppLogo(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: context.read<AuthController>().continueWithGoogle,
              child: const Text('Continue With Google'),
            ),
          ],
        ),
      ),
    );
  }
}
