import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryOrange,
    scaffoldBackgroundColor: Colors.grey[50],
    fontFamily: GoogleFonts.poppins().fontFamily,  // Police moderne
    
    textTheme: TextTheme(
      // Titres catégories
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
      // Mots du jeu
      displayLarge: GoogleFonts.poppins(
        fontSize: 64,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -1.0,
      ),
      // Countdown
      displayMedium: GoogleFonts.montserrat(
        fontSize: 120,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      // Boutons
      labelLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        textStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
