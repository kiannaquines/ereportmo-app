import 'package:flutter/material.dart';
import 'register.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const EReportMoApp());
}

class EReportMoApp extends StatelessWidget {
  const EReportMoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ThemeData incidentReportingTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal.shade700,
        primary: Colors.teal.shade700, // Main buttons, app bar
        secondary: Colors.amber.shade600, // Warnings, highlights
        surface: Colors.white, // Cards, dialogs
        onPrimary: Colors.white, // Text on red
        onSecondary: Colors.black, // Text on amber
        onSurface: Colors.black87, // Card text
        error: Colors.red.shade800, // Validation errors
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.teal.shade700,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.grey.shade100,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
        headlineMedium: GoogleFonts.poppins(
          textStyle: textTheme.headlineMedium,
        ),
        headlineSmall: GoogleFonts.openSans(textStyle: textTheme.headlineSmall),
        titleLarge: GoogleFonts.openSans(textStyle: textTheme.titleLarge),
        titleMedium: GoogleFonts.openSans(textStyle: textTheme.titleMedium),
        titleSmall: GoogleFonts.openSans(textStyle: textTheme.titleSmall),
        bodyLarge: GoogleFonts.openSans(textStyle: textTheme.bodyLarge),
        bodySmall: GoogleFonts.openSans(textStyle: textTheme.bodySmall),
        labelLarge: GoogleFonts.openSans(textStyle: textTheme.labelLarge),
        labelMedium: GoogleFonts.openSans(textStyle: textTheme.labelMedium),
        labelSmall: GoogleFonts.openSans(textStyle: textTheme.labelSmall),
        displayLarge: GoogleFonts.openSans(textStyle: textTheme.displayLarge),
        displayMedium: GoogleFonts.openSans(textStyle: textTheme.displayMedium),
        displaySmall: GoogleFonts.openSans(textStyle: textTheme.displaySmall),
        headlineLarge: GoogleFonts.openSans(textStyle: textTheme.headlineLarge),
      ),
    );
    return MaterialApp(
      title: 'EReportMoApp',
      debugShowCheckedModeBanner: false,
      theme: incidentReportingTheme,
      home: const RegisterScreen(),
    );
  }
}
