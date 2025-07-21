import 'package:bookcite/authentication/login_page.dart';
import 'package:bookcite/genre_page/genre_page.dart';
import 'package:bookcite/homepage/home_page.dart';
import 'package:bookcite/search_page/search_page.dart';
import 'package:bookcite/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorButtonPrimary),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).copyWith(
        headlineLarge: GoogleFonts.outfit(
          fontSize: MediaQuery.of(context).size.height * 37/852,
          fontWeight: FontWeight.w800
        ),

          headlineMedium: GoogleFonts.outfit(
            fontSize: MediaQuery.of(context).size.height * 30/852,
            fontWeight: FontWeight.w800
          ),

          headlineSmall: GoogleFonts.outfit(
            fontSize: MediaQuery.of(context).size.height * 23/852,
            fontWeight: FontWeight.w200
          ),

          bodyMedium: GoogleFonts.outfit(
            fontSize: MediaQuery.of(context).size.height * 18/852,
            fontWeight: FontWeight.bold
          ),

          labelLarge: GoogleFonts.outfit(
            fontSize: MediaQuery.of(context).size.height * 18/852,
          ),

          labelMedium: GoogleFonts.outfit(
            fontSize: MediaQuery.of(context).size.height * 15/852
          ),

          labelSmall: GoogleFonts.outfit(
            fontSize: MediaQuery.of(context).size.height * 9/852
          )

        ),
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}

