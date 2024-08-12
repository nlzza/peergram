import 'package:flutter/material.dart';

import '../app/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.flutter_dash,
          size: 128,
          color: AppTheme.primaryColor,
        ),
        SizedBox(height: 10),
        Text(
          'Peergram',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
