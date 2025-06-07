import 'package:ereportmo_app/login.dart';
import 'package:ereportmo_app/report.dart';
import 'package:ereportmo_app/report_incident.dart';
import 'package:ereportmo_app/type.dart';
import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(withBackButton: false, title: 'Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Welcome, Kian Naquines!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text('This is your personalized dashboard'),
                const SizedBox(height: 32),

                LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    double cardWidth =
                        screenWidth < 600 ? screenWidth / 2 - 32 : 200;

                    return Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildCard(
                          image: 'images/report-list.png',
                          label: 'Report List',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => const ReportScreen(
                                      title: 'Report List',
                                    ),
                              ),
                            );
                          },
                          width: cardWidth,
                        ),
                        _buildCard(
                          image: 'images/warning-sign.png',
                          label: 'Report Incidents',
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
                          image: 'images/incident-type.png',
                          label: 'Incident Type',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => const TypeScreen(
                                      title: 'Incident Type',
                                    ),
                              ),
                            );
                          },
                          width: cardWidth,
                        ),
                        _buildCard(
                          image: 'images/logout.png',
                          label: 'Logout',
                          onTap: () {
                            _showLogoutDialog(context);
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
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Dismiss dialog
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Then replace the screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(title: 'Login'),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Logout'),
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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: onTap,
          autofocus: false,
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
                    width: width * 0.4,
                    height: width * 0.4,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
}
