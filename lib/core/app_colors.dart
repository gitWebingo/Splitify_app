import 'package:flutter/material.dart';

class AppColors {
  // THREE-COLOR PALETTE: #700F70 (Light/Primary), #5A0C5A (Dark/Text), White
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFEFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border =
      Color(0xFFEFE6EF); // Extra soft purple hairline border

  // Core Purples
  static const Color mainColorLight = Color(0xFF700F70); // Light Purple #700F70
  static const Color mainColorDark = Color(0xFF5A0C5A); // Dark Purple #5A0C5A

  // High-End Semantic Mapping
  static const Color mainColor = mainColorLight;
  static const Color textPrimary = mainColorDark;

  // Depth Tints (Opacities of the 2 purples to stay within the 3-color rule)
  static final Color textSecondary = mainColorDark.withOpacity(0.65);
  static final Color textDisabled = mainColorDark.withOpacity(0.35);
  static final Color primaryLight = mainColorLight.withOpacity(0.08);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [mainColorLight, mainColorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient softGradient = LinearGradient(
    colors: [mainColorLight.withOpacity(0.05), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Forward Compatibility Mapping
  static const Color success = mainColorLight;
  static const Color error = mainColorDark;
  static final Color settled = textDisabled;
}
