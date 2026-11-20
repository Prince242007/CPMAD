import 'package:flutter/material.dart';

class AppTheme {
  // Change this to Colors.orange for the Hot Reload demonstration.
  static const seedColor = Colors.teal;
  static const appTitle = 'DailyBite';

  static ThemeData create(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
