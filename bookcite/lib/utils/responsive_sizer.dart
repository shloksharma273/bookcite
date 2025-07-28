import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponsiveSizer {
  static const double _designWidth = 375.0; // Your design's reference width
  static const double _designHeight = 812.0; // Your design's reference height

  // A static method to get a responsive font size, now requiring screenHeight
  static double getFontSize(double px, double screenHeight) {
    return (px / _designHeight) * screenHeight;
  }

  // A static method to create a TextTheme with responsive font sizes
  static TextTheme createResponsiveTextTheme(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).copyWith( // Can still copy existing textTheme
        headlineLarge: GoogleFonts.outfit(
            fontSize: getFontSize(37, screenHeight),
            fontWeight: FontWeight.w800
        ),
        headlineMedium: GoogleFonts.outfit(
            fontSize: getFontSize(30, screenHeight),
            fontWeight: FontWeight.w800
        ),
        headlineSmall: GoogleFonts.outfit(
            fontSize: getFontSize(23, screenHeight),
            fontWeight: FontWeight.w200
        ),
        bodyMedium: GoogleFonts.outfit(
            fontSize: getFontSize(18, screenHeight),
            fontWeight: FontWeight.bold
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: getFontSize(18, screenHeight),
          color: Colors.black
        ),
        labelMedium: GoogleFonts.outfit(
            fontSize: getFontSize(15, screenHeight),
            color: Colors.black
        ),
        labelSmall: GoogleFonts.outfit(
            fontSize: getFontSize(9, screenHeight),
            color: Colors.black
        )
    );
  }
}