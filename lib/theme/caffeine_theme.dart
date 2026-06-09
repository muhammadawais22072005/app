import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CaffeineTheme {
  // Brand color palette
  static const Color espresso = Color(0xFF1A0A00); // Base canvas
  static const Color background = Color(0xFF15130F); // Tonal dark background
  static const Color surface = Color(0xFF221F1B); // Surface cards
  static const Color surfaceBright = Color(0xFF3C3933);
  static const Color outline = Color(0xFF9B8E85);
  
  static const Color amber = Color(0xFFC9813A); // Caramel Amber Accent
  static const Color cream = Color(0xFFF5E6CC); // Warm Cream border & details
  static const Color offWhite = Color(0xFFFDF6EE); // High-contrast text
  static const Color secondary = Color(0xFFFFB877); // Soft light orange
  static const Color onSecondary = Color(0xFF4B2700);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: amber,
      scaffoldBackgroundColor: espresso,
      colorScheme: const ColorScheme.dark(
        primary: amber,
        secondary: secondary,
        onSecondary: onSecondary,
        surface: surface,
        background: espresso,
        onBackground: offWhite,
        onSurface: offWhite,
        outline: outline,
        error: Color(0xFFFFB4AB),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: offWhite,
          letterSpacing: -0.02,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: offWhite,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColorState,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: offWhite,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: offWhite.withOpacity(0.85),
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: offWhite,
          letterSpacing: 0.05,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: outline,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cream.withOpacity(0.08), width: 1),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: amber,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButtonStyleFrom.style,
      ),
    );
  }

  static Color get primaryColorState => amber;

  static ButtonStyle get amberButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: amber,
    foregroundColor: offWhite,
    elevation: 0,
    shadowColor: amber.withOpacity(0.35),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  static ButtonStyle get creamOutlineButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: cream,
    side: BorderSide(color: cream.withOpacity(0.2), width: 1),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  static BoxDecoration get glassDecoration => BoxDecoration(
    color: espresso.withOpacity(0.4),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: cream.withOpacity(0.05),
      width: 1,
    ),
  );

  static BoxDecoration get amberGlowDecoration => BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: amber.withOpacity(0.25),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ],
  );
}

// Helper to handle elevated button styling cleanly in Dart
class ElevatedButtonStyleFrom {
  static ButtonStyle get style => ElevatedButton.styleFrom(
    backgroundColor: CaffeineTheme.amber,
    foregroundColor: CaffeineTheme.espresso,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}
