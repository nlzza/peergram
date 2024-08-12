import 'package:flutter/material.dart';

import '../app/app_theme.dart';

class OverlayService {
  static final instance = OverlayService._();
  OverlayService._();

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void showSnackbar(String message, {Color color = AppTheme.primaryColor}) {
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: SelectableText(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void showError(String message) {
    showSnackbar(message, color: AppTheme.errorColor);
  }

  Future<void> catchError(dynamic error) async {
    showError(error.toString());
  }
}
