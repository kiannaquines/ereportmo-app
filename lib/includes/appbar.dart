import 'package:flutter/material.dart';

class EReportModeAppBar extends StatefulWidget {
  const EReportModeAppBar({
    super.key,
    this.title = 'EReportMo',
    this.withBackButton = true,
    this.withActionButtons = false,
  });

  final String title;
  final bool withBackButton;
  final bool withActionButtons;

  @override
  State<EReportModeAppBar> createState() => _EReportModeAppBarState();
}

class _EReportModeAppBarState extends State<EReportModeAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: Colors.white,
      actions: [
        if (widget.withActionButtons)
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        if (widget.withActionButtons) const SizedBox(width: 10),
        if (widget.withActionButtons)
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        if (widget.withActionButtons) const SizedBox(width: 10),
      ],
    );
  }
}
