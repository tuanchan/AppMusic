// utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color neonRed = Color(0xFFFF0040);
  static const Color darkRed = Color(0xFF8B0000);
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color lightGray = Color(0xFF2A2A2A);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFFB0B0B0);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,

      // Primary
      primaryColor: neonRed,

      // ✅ Material3-friendly color scheme (stable across Flutter versions)
      colorScheme: ColorScheme.fromSeed(
        seedColor: neonRed,
        brightness: Brightness.dark,
        primary: neonRed,
        secondary: darkRed,
        surface: darkGray,
        error: const Color(0xFFB00020),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).copyWith(
        iconTheme: const IconThemeData(color: neonRed),
      ),

      // Card
      cardTheme: CardThemeData(
        color: darkGray,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: neonRed.withOpacity(0.3), width: 1),
        ),
      ),

      // Icon
      iconTheme: const IconThemeData(color: neonRed),

      // Text
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textWhite, fontSize: 16),
        bodyMedium: TextStyle(color: textGray, fontSize: 14),
        labelLarge: TextStyle(
          color: neonRed,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonRed,
          foregroundColor: textWhite,
          elevation: 8,
          shadowColor: neonRed.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: neonRed,
        ),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: neonRed,
        inactiveTrackColor: lightGray,
        thumbColor: neonRed,
        overlayColor: neonRed.withOpacity(0.2),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonRed.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonRed.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonRed, width: 2),
        ),
        labelStyle: const TextStyle(color: textGray),
        hintStyle: TextStyle(color: textGray.withOpacity(0.5)),
      ),
    );
  }

  static BoxDecoration neonGlow({Color? color}) {
    final Color glowColor = color ?? neonRed;

    return BoxDecoration(
      color: (color ?? neonRed).withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }
}
