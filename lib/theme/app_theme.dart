import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get premiumTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF090B1A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7DF9FF),
        secondary: Color(0xFF5B6BFF),
        surface: Color(0xFF10142A),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.bebasNeue(
            fontSize: 52, letterSpacing: 2, color: Colors.white),
        titleLarge:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: const TextStyle(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9C5FFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF111437),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
