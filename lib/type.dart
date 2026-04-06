import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:flutter/material.dart';

class TypeScreen extends StatefulWidget {
  const TypeScreen({super.key, required this.title});

  final String title;

  @override
  State<TypeScreen> createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
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
                subtitle: 'Choose the report type from this screen.',
                showBackButton: true,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Type',
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
