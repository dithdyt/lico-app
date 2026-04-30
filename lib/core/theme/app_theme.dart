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
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          color: pureWhite,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          color: pureWhite.withOpacity(0.8),
        ),
        labelLarge: GoogleFonts.bebasNeue(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: pureBlack,
        ),
      ),

      // Card Theme (Neo-Brutalism: Thick borders, no elevation)
      cardTheme: CardTheme(
        color: darkGrey,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: pureWhite, width: 2.0),
          borderRadius: BorderRadius.circular(0), // Sharp edges for brutalism
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          borderSide: BorderSide(color: neonYellow, width: 3.0),
          borderRadius: BorderRadius.zero,
        ),
        labelStyle: GoogleFonts.inter(color: pureWhite),
        hintStyle: GoogleFonts.inter(color: pureWhite.withOpacity(0.5)),
      ),
    );
  }
}
