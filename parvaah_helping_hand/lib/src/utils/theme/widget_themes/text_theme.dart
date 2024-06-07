import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(color: Colors.black87),
    headlineMedium: GoogleFonts.poppins(color: Colors.black87),
  );
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(color: Colors.white),
    headlineMedium: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
  );
}
