import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:ereportmo_app/includes/ui_shell.dart';
import 'package:flutter/material.dart';

class EReportModeAppBar extends StatelessWidget {
  const EReportModeAppBar({
    super.key,
    this.title = 'EReportMo',
    this.withBackButton = true,
    this.withActionButtons = false,
    this.elevation = 0,
  });

  final String title;
  final bool withBackButton;
  final bool withActionButtons;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 78,
      backgroundColor: Colors.transparent,
      foregroundColor: kAppTitleText,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kAppFieldBorder),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3A2118).withValues(alpha: 0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                if (withBackButton)
                  _AppBarIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.maybePop(context),
                    tooltip: 'Back',
                  )
                else
                  const SizedBox(width: 44),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kAppTitleText,
                      ),
                    ),
                  ),
                ),
                if (withActionButtons)
                  const Row(
                    children: [
                      _AppBarIconButton(
                        icon: Icons.notifications_none_rounded,
                        tooltip: 'Notifications',
                      ),
                      SizedBox(width: 8),
                      _AppBarIconButton(
                        icon: Icons.more_horiz_rounded,
                        tooltip: 'More',
                      ),
                    ],
                  )
                else
                  const SizedBox(width: 44),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({required this.icon, this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: const Color(0xFFFFF5F0),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20, color: kAppAccent),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
