import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Neo-Brutalism Palette
  static const Color neonYellow = Color(0xFFCCFF00);
  static const Color pureBlack = Color(0xFF000000);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color errorRed = Color(0xFFFF3B30);
  static const Color successGreen = Color(0xFF34C759);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pureBlack,
      primaryColor: neonYellow,
      
      colorScheme: const ColorScheme.dark(
        primary: neonYellow,
        secondary: neonYellow,
        surface: darkGrey,
        onPrimary: pureBlack,
        onSurface: pureWhite,
        error: errorRed,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.bebasNeue(
          fontSize: 96,
          fontWeight: FontWeight.bold,
          color: pureWhite,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.bebasNeue(
          fontSize: 60,
          fontWeight: FontWeight.bold,
          color: pureWhite,
          letterSpacing: 1.2,
        ),
        displaySmall: GoogleFonts.bebasNeue(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: pureWhite,
        ),
        headlineMedium: GoogleFonts.bebasNeue(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: pureWhite,
        ),
        headlineSmall: GoogleFonts.bebasNeue(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: pureWhite,
        ),
        titleLarge: GoogleFonts.bebasNeue(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: pureWhite,
          letterSpacing: 1.2,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          color: pureWhite,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          color: pureWhite.withValues(alpha: 0.8),
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          color: pureWhite.withValues(alpha: 0.6),
        ),
        labelLarge: GoogleFonts.bebasNeue(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: neonYellow,
        ),
        labelMedium: GoogleFonts.bebasNeue(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: pureWhite,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: pureBlack,
        elevation: 0,
        iconTheme: const IconThemeData(color: neonYellow),
        actionsIconTheme: const IconThemeData(color: neonYellow),
        centerTitle: false,
        titleTextStyle: GoogleFonts.bebasNeue(
          color: pureWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),

      // Card Theme (Neo-Brutalism: Thick borders, no elevation)
      cardTheme: const CardThemeData(
        color: darkGrey,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: pureWhite, width: 2.0),
          borderRadius: BorderRadius.zero,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonYellow,
          foregroundColor: pureBlack,
          elevation: 0,
          shape: const ContinuousRectangleBorder(
            side: BorderSide(color: pureWhite, width: 2.0),
          ),
          textStyle: GoogleFonts.bebasNeue(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Text Selection Theme (Cursor)
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: neonYellow,
        selectionColor: neonYellow,
        selectionHandleColor: neonYellow,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGrey,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: pureWhite, width: 2.0),
          borderRadius: BorderRadius.zero,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: pureWhite, width: 2.0),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: neonYellow, width: 2.0),
          borderRadius: BorderRadius.zero,
        ),
        labelStyle: GoogleFonts.inter(color: pureWhite),
        hintStyle: GoogleFonts.inter(color: pureWhite.withValues(alpha: 0.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
