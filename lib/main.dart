import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ereportmo_app/dashboard.dart';
import 'package:ereportmo_app/login.dart';
import 'package:ereportmo_app/includes/ereportmo_shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal.shade700,
        primary: Colors.teal.shade700,
        secondary: Colors.amber.shade600,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black87,
        error: Colors.red.shade800,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.teal.shade700,
        actionTextColor: Colors.white,
        contentTextStyle: const TextStyle(color: Colors.white),
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
      textTheme: GoogleFonts.openSansTextTheme(textTheme).copyWith(
        bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.teal)),
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
