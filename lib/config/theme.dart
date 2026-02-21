import 'package:flutter/material.dart';

/// Theme mode enum for light, dark, and system options
enum AppThemeMode {
  light,
  dark,
  system,
}

/// App-wide theme constants
class AppTheme {
  AppTheme._();

  // Light theme colors
  static const Color _lightPrimaryColor = Color(0xFF4A90E2);
  static const Color _lightBackgroundColor = Color(0xFFF7FAFF);
  static const Color _lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color _lightCardColor = Color(0xFFFFFFFF);

  // Dark theme colors
  static const Color _darkPrimaryColor = Color(0xFF1E88E5);
  static const Color _darkBackgroundColor = Color(0xFF0D1117);
  static const Color _darkSurfaceColor = Color(0xFF0F1720);
  static const Color _darkCardColor = Color(0xFF0F1720);

  /// Light theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _lightPrimaryColor,
      scaffoldBackgroundColor: _lightBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightPrimaryColor,
        brightness: Brightness.light,
        primary: _lightPrimaryColor,
        surface: _lightSurfaceColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurfaceColor,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: _lightCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFD9D9D9).withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const Color(0xFFD9D9D9),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const Color(0xFFD9D9D9),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _lightPrimaryColor, width: 2),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black54,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.grey),
      ),
    );
  }

  /// Dark theme data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _darkPrimaryColor,
      scaffoldBackgroundColor: _darkBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _darkPrimaryColor,
        brightness: Brightness.dark,
        primary: _darkPrimaryColor,
        surface: _darkSurfaceColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurfaceColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: _darkCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: Colors.grey[800]!,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: Colors.grey[800]!,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _darkPrimaryColor, width: 2),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white70,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
      ),
    );
  }

  // Additional colors for custom UI elements
  static Color getLightBackgroundGradientEnd() => const Color(0xFFFFFFFF);
  static Color getDarkBackgroundGradientEnd() => const Color(0xFF071019);

  // Card and container colors
  static Color getLightCardColor() => Colors.white;
  static Color getDarkCardColor() => const Color(0xFF0F1720);

  // Text colors
  static Color getLightPrimaryText() => Colors.black87;
  static Color getDarkPrimaryText() => Colors.white;
  static Color getLightSecondaryText() => Colors.grey[700]!;
  static Color getDarkSecondaryText() => Colors.white70;

  // Gradient backgrounds
  static List<Color> get lightGradient => [
    const Color(0xFFF7FAFF),
    const Color(0xFFFFFFFF),
  ];

  static List<Color> get darkGradient => [
    const Color(0xFF0D1117),
    const Color(0xFF071019),
  ];
}
