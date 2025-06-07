import 'package:flutter/material.dart';
import 'package:ereportmo_app/includes/appbar.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: EReportModeAppBar(withBackButton: true, title: widget.title),
      ),
      body: const Center(child: Text('Type')),
    );
  }
}
