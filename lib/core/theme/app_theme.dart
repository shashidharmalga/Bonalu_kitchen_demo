import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFFFF5722); // Deep Premium Orange
  static const secondaryColor = Color(0xFFFFC107); // Gold
  static const darkBackgroundColor = Color(0xFF0D0D0D); // True Dark
  static const darkSurfaceColor = Color(0xFF1A1A1A); // Dark Card
  static const lightBackgroundColor = Color(0xFFF9F9F9); // Crisp Light Gray
  static const lightSurfaceColor = Color(0xFFFFFFFF); // Pure White Card

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      background: darkBackgroundColor,
      surface: darkSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -0.5),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 20, letterSpacing: -0.3),
      bodyLarge: GoogleFonts.outfit(fontSize: 16),
      labelLarge: GoogleFonts.outfit(fontWeight: FontWeight.w500),
    ),
    cardTheme: CardThemeData(
      color: darkSurfaceColor,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 0,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      background: lightBackgroundColor,
      surface: lightSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: lightBackgroundColor,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -0.5, color: Colors.black87),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 20, letterSpacing: -0.3, color: Colors.black87),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, color: Colors.black87),
      labelLarge: GoogleFonts.outfit(fontWeight: FontWeight.w500, color: Colors.black87),
    ),
    cardTheme: CardThemeData(
      color: lightSurfaceColor,
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 0,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black87,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
    ),
  );
}
