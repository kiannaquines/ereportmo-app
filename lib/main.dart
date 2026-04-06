import 'package:ereportmo_app/dashboard.dart';
import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/login.dart';
import 'package:ereportmo_app/includes/ereportmo_shared.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_PH');
  runApp(const EReportMoApp());
}

class EReportMoApp extends StatelessWidget {
  const EReportMoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EReportMoApp',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const EntryPoint(),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.light();
    final textTheme = base.textTheme;
    const primary = kAppAccent;
    const secondary = Color(0xFFFFB29E);
    const surface = Colors.white;
    const outline = kAppFieldBorder;
    const muted = kAppMutedText;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: const Color(0xFF20222B),
        error: const Color(0xFFDC2626),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        actionTextColor: Colors.white,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      scaffoldBackgroundColor: kAppCanvas,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kAppFieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        labelStyle: GoogleFonts.inter(
          color: muted,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 1.6),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(textTheme).copyWith(
        titleLarge: GoogleFonts.inter(
          textStyle: textTheme.titleLarge,
          fontWeight: FontWeight.w800,
          color: kAppTitleText,
        ),
        titleMedium: GoogleFonts.inter(
          textStyle: textTheme.titleMedium,
          fontWeight: FontWeight.w700,
          color: kAppTitleText,
        ),
        bodyMedium: GoogleFonts.inter(
          textStyle: textTheme.bodyMedium,
          color: kAppLabelText,
          height: 1.45,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: muted,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getSecureToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(color: kAppAccent),
            ),
          );
        } else {
          final token = snapshot.data;
          if (token != null && token.isNotEmpty) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }
}
