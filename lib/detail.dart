import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:flutter/material.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key, required this.title});

  final String title;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppCanvas,
      body: SafeArea(
        child: Padding(
          padding: appScreenPadding(context),
          child: buildScreenPanel(
            context: context,
            children: [
              buildScreenHeader(
                context,
                title: widget.title,
                subtitle: 'Review the selected report details.',
                showBackButton: true,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: kAppTitleText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
