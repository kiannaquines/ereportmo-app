import 'dart:async';
import 'dart:convert';

import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/login.dart';
import 'package:ereportmo_app/report.dart';
import 'package:ereportmo_app/report_incident.dart';
import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ereportmo_app/includes/ereportmo_shared.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userName;
  @override
  void initState() {
    super.initState();
    getUserName().then((value) {
      if (mounted) {
        setState(() {
          userName = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(
          withBackButton: false,
          title: 'EReportMo',
          withActionButtons: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${userName ?? ''}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Help keep your community safe by reporting incidents.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Quick Actions',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              'Quickly access important features',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
                fontFamily: GoogleFonts.openSans().fontFamily,
                color: colorScheme.onSecondary.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = MediaQuery.of(context).size.width;
                final cardHeight = cardWidth * 0.5;

                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.warning_amber_rounded,
                      label: 'Report Incident',
                      description: 'Report any incident in your area',
                      color: colorScheme.primary,
                      height: cardHeight,
                      width: cardWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const ReportIncident(
                                  title: 'Report Incident',
                                ),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.history_rounded,
                      label: 'Report History',
                      description: 'View your reported incidents',
                      color: colorScheme.secondary,
                      height: cardHeight,
                      width: cardWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4), // Added smaller spacing
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    // Changed to bodyMedium
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface.withOpacity(
                      0.7,
                    ), // Reduced opacity
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedFontSize: 12,
        currentIndex: 0,
        elevation: 0,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            activeIcon: Icon(Icons.logout_rounded),
            label: 'Logout',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportScreen()),
            );
          } else if (index == 2) {
            _showLogoutDialog(context);
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logout',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Are you sure you want to logout?',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await logOutData();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildCard({
    required String image,
    required String label,
    required VoidCallback onTap,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: onTap,
          autofocus: false,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: label,
                  child: Image.asset(
                    image,
                    width: width * 0.3,
                    height: width * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: GoogleFonts.openSans().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logOutData() async {
    final token = await getSecureToken();
    final response = await http.post(
      Uri.parse('$baseApiUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    final responseMessage = jsonDecode(response.body)['message'];
    final message = responseMessage ?? 'Logged out successfully';

    if (response.statusCode == 200) {
      await removeLoginData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      });
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong please try again.',
            style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
    }
  }
}
