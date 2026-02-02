import 'package:flutter/material.dart';

class AppColors {
  // Image-Inspired Palette: Midnight Charcoal + Vibrant Emerald
  static const Color background = Color(0xFF0B0E11); // Deep Midnight Charcoal
  static const Color surface = Color(0xFF1C1F22); // Field/Card Background
  static const Color card = Color(0xFF1C1F22); // Consistent dark cards

  static const Color mainColor = Color(0xFF00A86B); // Vibrant Emerald Green
  static const Color accent = Color(0xFF00A86B);
  static const Color secondaryColor = Color(0xFF666D74); // Slate Grey
  static const Color lightColor = Color(0xFFFFFFFF); // Pure White

  static const Color primaryStart = mainColor;
  static const Color primaryEnd = Color(0xFF008D5A); // Deep Green
  static const Color accentStart = mainColor;
  static const Color accentEnd = Color(0xFF008D5A);

  // Status Colors
  static const Color owe = Color(0xFFEF4444); // Pure Red
  static const Color owed = mainColor; // Emerald Green
  static const Color settled = secondaryColor;

  // Text Hierarchy
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF7C8187); // Soft Grey
  static const Color textDisabled = Color(0xFF3F444A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryStart, primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentStart, accentEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oweGradient = LinearGradient(
    colors: [owe, Color(0xFFB91C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient owedGradient = LinearGradient(
    colors: [owed, Color(0xFF006D45)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
