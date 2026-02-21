import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFF080808);
  static const Color backgroundSecondary = Color(0xFF101010);
  static const Color backgroundRedHint = Color(0xFF1A0000);
  static const Color backgroundRedDark = Color(0xFF0D0000);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF242424);

  // Red palette (primary)
  static const Color red = Color(0xFF8B0000);
  static const Color redBright = Color(0xFFC0392B);
  static const Color redLight = Color(0xFFE57373);
  static const Color redDark = Color(0xFF560000);

  // Gold palette (subtle / accent)
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8D5A3);
  static const Color goldDark = Color(0xFF8B6914);
  static const Color goldMuted = Color(0xFF5A4A20);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textMuted = Color(0xFF555555);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  // Divider / Border
  static const Color divider = Color(0xFF2A2A2A);
  static const Color border = Color(0xFF2A2A2A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [redDark, red, redBright, red, redDark],
    stops: [0.0, 0.3, 0.5, 0.7, 1.0],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldDark, gold, goldLight, gold, goldDark],
    stops: [0.0, 0.3, 0.5, 0.7, 1.0],
  );

  static const RadialGradient splashBackgroundGradient = RadialGradient(
    center: Alignment(0.0, -0.2),
    radius: 1.2,
    colors: [backgroundRedHint, backgroundRedDark, background],
    stops: [0.0, 0.5, 1.0],
  );
}
