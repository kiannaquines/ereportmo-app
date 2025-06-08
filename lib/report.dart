import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.title = 'Report List'});

  final String title;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(withBackButton: true, title: widget.title),
      ),
      body: const Center(child: Text('Report')),
    );
  }
}
