import 'package:flutter/material.dart';

class TvTheme {
  static const Color background = Color(0xFF090D16);
  static const Color surface = Color(0xFF131B2E);
  static const Color surfaceCard = Color(0xFF1E293B);
  static const Color primaryBlue = Color(0xFF38BDF8);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        surface: surface,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textPrimary, fontSize: 36, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textSecondary, fontSize: 18),
      ),
    );
  }
}
