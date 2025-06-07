import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';

class ReportIncident extends StatefulWidget {
  const ReportIncident({super.key, required this.title});

  final String title;

  @override
  State<ReportIncident> createState() => _ReportIncidentState();
}

class _ReportIncidentState extends State<ReportIncident> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(withBackButton: true, title: widget.title),
      ),
      body: const Center(child: Text('Report Incident')),
    );
  }
}
