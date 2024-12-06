import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTypography {
  static TextTheme get poppinsTextTheme {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 96.0,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 60.0,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 48.0,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 34.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
      ),
    );
  }
}
