import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Slate Dark Palette
  static const Color slateBg = Color(0xFF0F172A); // Deep Slate
  static const Color slateSurface = Color(0xFF1E293B); // Slate Gray
  static const Color indigoAccent = Color(0xFF6366F1); // Indigo Accent
  static const Color indigoAccentLight = Color(0xFF818CF8); // Light Indigo
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color slateTextPrimary = Color(0xFFF8FAFC); // Very light slate
  static const Color slateTextSecondary = Color(0xFF94A3B8); // Muted slate
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: slateBg,
      primaryColor: indigoAccent,
      
      colorScheme: const ColorScheme.dark(
        primary: indigoAccent,
        secondary: indigoAccentLight,
        surface: slateSurface,
        onPrimary: pureWhite,
        onSurface: slateTextPrimary,
        error: errorRed,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 72,
          fontWeight: FontWeight.extrabold,
          color: slateTextPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 48,
          fontWeight: FontWeight.extrabold,
          color: slateTextPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.plusJakartaSans(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: slateTextPrimary,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: slateTextPrimary,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: slateTextPrimary,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: slateTextPrimary,
          letterSpacing: 0.1,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: slateTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: slateTextSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: slateTextSecondary.withOpacity(0.8),
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: indigoAccentLight,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: slateTextPrimary,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: slateBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: indigoAccentLight),
        actionsIconTheme: const IconThemeData(color: indigoAccentLight),
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: slateTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card Theme (Modern: Rounded corners with subtle background)
      cardTheme: CardThemeData(
        color: slateSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: slateTextSecondary.withOpacity(0.1), width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: indigoAccent,
          foregroundColor: pureWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Selection Theme (Cursor)
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: indigoAccent,
        selectionColor: Color(0x406366F1), // 25% opacity indigo
        selectionHandleColor: indigoAccent,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: slateSurface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: slateTextSecondary.withOpacity(0.2), width: 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: slateTextSecondary.withOpacity(0.2), width: 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: indigoAccent, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: errorRed, width: 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: GoogleFonts.inter(color: slateTextSecondary),
        hintStyle: GoogleFonts.inter(color: slateTextSecondary.withOpacity(0.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
