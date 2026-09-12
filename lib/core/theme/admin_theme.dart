import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AdminTheme {
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AdminColors.darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AdminColors.primaryGold,
        brightness: Brightness.dark,
        primary: AdminColors.primaryGold,
        secondary: AdminColors.goldAccent,
        surface: AdminColors.darkSurface,
        error: AdminColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AdminColors.darkHeader,
        foregroundColor: AdminColors.textDarkPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AdminColors.textDarkPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AdminColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AdminColors.darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AdminColors.primaryGold,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AdminColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AdminColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AdminColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AdminColors.primaryGold, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(color: AdminColors.textDarkSecondary, fontSize: 13),
        hintStyle: GoogleFonts.poppins(color: AdminColors.textMuted, fontSize: 13),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AdminColors.darkCard,
        contentTextStyle: GoogleFonts.poppins(color: AdminColors.textDarkPrimary),
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: AdminColors.textDarkPrimary),
        headlineLarge: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: AdminColors.textDarkPrimary),
        headlineMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: AdminColors.textDarkPrimary),
        titleLarge: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600, color: AdminColors.textDarkPrimary),
      ),
    );
  }
}
