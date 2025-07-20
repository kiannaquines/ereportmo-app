import 'package:flutter/material.dart';

class EReportModeAppBar extends StatefulWidget {
  const EReportModeAppBar({
    super.key,
    this.title = 'EReportMo',
    this.withBackButton = true,
    this.withActionButtons = false,
    this.elevation = 1,
  });

  final String title;
  final bool withBackButton;
  final bool withActionButtons;
  final double elevation;

  @override
  State<EReportModeAppBar> createState() => _EReportModeAppBarState();
}

class _EReportModeAppBarState extends State<EReportModeAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      leading:
          widget.withBackButton
              ? IconButton(
                icon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 20),
                ),
                onPressed: () => Navigator.maybePop(context),
                tooltip: 'Back',
              )
              : null,
      title: Text(
        widget.title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: widget.elevation,
      shadowColor: Colors.black.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      actions: [
        if (widget.withActionButtons) ...[
          IconButton(
            icon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_outlined, size: 20),
            ),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_vert_rounded, size: 20),
            ),
            onPressed: () {},
            tooltip: 'Menu',
          ),
          const SizedBox(width: 8),
        ],
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
    );
  }
}
