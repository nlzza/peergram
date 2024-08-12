import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Colors.teal;
  static const errorColor = Colors.red;
  static final colors = ColorScheme.fromSeed(seedColor: primaryColor);

  static final theme = ThemeData(
    colorScheme: colors,
    cardColor: primaryColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      enabledBorder: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 32, color: Colors.black, height: 1.5),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
    ),
  );
}
