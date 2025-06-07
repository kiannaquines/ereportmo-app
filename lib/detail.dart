import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.title});

  final String title;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(withBackButton: true),
      ),
      body: const Center(child: Text('Detail')),
    );
  }
}
