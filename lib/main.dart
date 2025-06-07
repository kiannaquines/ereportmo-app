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
        seedColor: Colors.red.shade700,
        primary: Colors.red.shade700, // Main buttons, app bar
        secondary: Colors.amber.shade600, // Warnings, highlights
        surface: Colors.white, // Cards, dialogs
        onPrimary: Colors.white, // Text on red
        onSecondary: Colors.black, // Text on amber
        onSurface: Colors.black87, // Card text
        error: Colors.red.shade800, // Validation errors
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black87,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.grey.shade100,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.oswald(textStyle: textTheme.bodyMedium),
        headlineMedium: GoogleFonts.oswald(textStyle: textTheme.headlineMedium),
        headlineSmall: GoogleFonts.oswald(textStyle: textTheme.headlineSmall),
        titleLarge: GoogleFonts.oswald(textStyle: textTheme.titleLarge),
        titleMedium: GoogleFonts.oswald(textStyle: textTheme.titleMedium),
        titleSmall: GoogleFonts.oswald(textStyle: textTheme.titleSmall),
        bodyLarge: GoogleFonts.oswald(textStyle: textTheme.bodyLarge),
        bodySmall: GoogleFonts.oswald(textStyle: textTheme.bodySmall),
        labelLarge: GoogleFonts.oswald(textStyle: textTheme.labelLarge),
        labelMedium: GoogleFonts.oswald(textStyle: textTheme.labelMedium),
        labelSmall: GoogleFonts.oswald(textStyle: textTheme.labelSmall),
        displayLarge: GoogleFonts.oswald(textStyle: textTheme.displayLarge),
        displayMedium: GoogleFonts.oswald(textStyle: textTheme.displayMedium),
        displaySmall: GoogleFonts.oswald(textStyle: textTheme.displaySmall),
        headlineLarge: GoogleFonts.oswald(textStyle: textTheme.headlineLarge),
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
