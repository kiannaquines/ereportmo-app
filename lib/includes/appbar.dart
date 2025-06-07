import 'package:flutter/material.dart';

class EReportModeAppBar extends StatefulWidget {
  const EReportModeAppBar({
    super.key,
    this.title = 'EReportMo',
    this.withBackButton = true,
  });

  final String title;
  final bool withBackButton;

  @override
  State<EReportModeAppBar> createState() => _EReportModeAppBarState();
}

class _EReportModeAppBarState extends State<EReportModeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          widget.withBackButton
              ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              )
              : null,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );
  }
}
