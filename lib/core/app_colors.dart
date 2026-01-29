import 'package:flutter/material.dart';

class AppColors {
  // Modern Dark Theme - Unique to Splitify
  static const Color background = Color(0xFF0A0E27); // Deep Space Blue
  static const Color surface = Color(0xFF151B3D); // Midnight Blue
  static const Color card = Color(0xFF1E2749); // Slate Blue

  // Unique Gradient Accent System
  static const Color primaryStart = Color(0xFF6366F1); // Indigo
  static const Color primaryEnd = Color(0xFF8B5CF6); // Purple
  static const Color accentStart = Color(0xFF10B981); // Emerald
  static const Color accentEnd = Color(0xFF06B6D4); // Cyan

  // Alias for compatibility
  static const Color accent = primaryStart;

  // Status Colors
  static const Color owe = Color(0xFFEF4444); // Red
  static const Color owed = Color(0xFF10B981); // Green
  static const Color settled = Color(0xFF8B5CF6); // Purple

  // Text Hierarchy
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF475569);

  // Unique Gradients
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
    colors: [Color(0xFF1E2749), Color(0xFF151B3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oweGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient owedGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
