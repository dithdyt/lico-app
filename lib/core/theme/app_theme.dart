import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color neonYellow = Color(0xFFCCFF00);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF1A1A1A);

  static ThemeData get dark {
    final baseTheme = ThemeData.dark();
    
    return baseTheme.copyWith(
      scaffoldBackgroundColor: black,
      primaryColor: neonYellow,
      colorScheme: const ColorScheme.dark(
        primary: neonYellow,
        secondary: neonYellow,
        surface: grey,
        background: black,
      ),
      cardTheme: CardTheme(
        color: grey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(color: white, width: 2.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.bebasNeue(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: white,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.bebasNeue(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: white,
          letterSpacing: 1.5,
        ),
        displaySmall: GoogleFonts.bebasNeue(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        headlineMedium: GoogleFonts.bebasNeue(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonYellow,
          foregroundColor: black,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(color: black, width: 2.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.bebasNeue(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: grey,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: white, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: white, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: neonYellow, width: 3.0),
        ),
        labelStyle: const TextStyle(color: white),
        hintStyle: TextStyle(color: white.withOpacity(0.5)),
      ),
    );
  }
}
