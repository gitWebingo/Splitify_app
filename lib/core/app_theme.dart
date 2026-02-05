import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get elegantTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.mainColor,
      splashColor: AppColors.mainColor.withOpacity(0.05),
      colorScheme: const ColorScheme.light(
        primary: AppColors.mainColor,
        onPrimary: Colors.white,
        secondary: AppColors.mainColor,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),
      textTheme:
          GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        titleLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        titleMedium: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.textDisabled,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
        extendedTextStyle:
            const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.mainColor, width: 1.5),
        ),
      ),
    );
  }
}
