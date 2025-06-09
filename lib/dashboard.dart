import 'dart:async';
import 'dart:convert';

import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/login.dart';
import 'package:ereportmo_app/report.dart';
import 'package:ereportmo_app/report_incident.dart';
import 'package:ereportmo_app/type.dart';
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
      setState(() {
        userName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.yellow.shade100,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.yellow.shade700, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi! $userName',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.openSans().fontFamily,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Help the community by reporting incidents.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                            fontFamily: GoogleFonts.openSans().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double cardWidth =
                      screenWidth < 600 ? screenWidth / 1 - 32 : 200;

                  return Wrap(
                    spacing: 20,
                    runSpacing: 24,
                    alignment: WrapAlignment.start,
                    children: [
                      _buildCard(
                        image: 'images/warning-sign.png',
                        label: 'Report Incident',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const ReportIncident(
                                    title: 'Report Incident',
                                  ),
                            ),
                          );
                        },
                        width: cardWidth,
                      ),
                      _buildCard(
                        image: 'images/report-list.png',
                        label: 'Report History',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ReportScreen(),
                            ),
                          );
                        },
                        width: cardWidth,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.of(context).push(
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
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Logout',
              style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontFamily: GoogleFonts.openSans().fontFamily),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Dismiss dialog
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: GoogleFonts.openSans().fontFamily,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  await logOutData();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontFamily: GoogleFonts.openSans().fontFamily,
                  ),
                ),
              ),
            ],
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
