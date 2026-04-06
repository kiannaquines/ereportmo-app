import 'dart:async';
import 'dart:convert';

import 'package:ereportmo_app/constants.dart';
import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ereportmo_shared.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:ereportmo_app/login.dart';
import 'package:ereportmo_app/report.dart';
import 'package:ereportmo_app/report_incident.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      backgroundColor: kAppCanvas,
      body: SingleChildScrollView(
        padding: appScreenPadding(context),
        child: buildScreenPanel(
          context: context,
          children: [
            buildProgressBar(context, 0.72),
            const SizedBox(height: 26),
            buildScreenHeader(
              context,
              title: 'Welcome Home',
              subtitle:
                  'Track reports, create new incidents, and keep your community updates organized.',
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: kAppAccentSoft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${userName ?? 'Reporter'}',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: kAppTitleText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Everything you need to report and review incidents is gathered here in one place.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: kAppLabelText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            buildSectionLabel('Quick Actions'),
            const SizedBox(height: 14),
            _buildActionTile(
              context,
              icon: Icons.add_task_rounded,
              title: 'Create Report',
              subtitle: 'Capture details and submit a new incident report.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            const ReportIncident(title: 'Report Incident'),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _buildActionTile(
              context,
              icon: Icons.event_note_rounded,
              title: 'Report History',
              subtitle: 'Review statuses and follow your submitted incidents.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: appSoftCardDecoration(),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: kAppAccentSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: kAppAccent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kAppTitleText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.4,
                        color: kAppMutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: kAppMutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: 0,
          elevation: 0,
          selectedItemColor: kAppAccent,
          unselectedItemColor: const Color(0xFFB2AAA2),
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
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportScreen()),
              );
            } else if (index == 2) {
              _showLogoutDialog(context);
            }
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Logout',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kAppTitleText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to logout from this device?',
                  style: GoogleFonts.inter(color: kAppMutedText, height: 1.5),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(color: kAppMutedText),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await logOutData();
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong please try again.')),
      );
    }
  }
}
