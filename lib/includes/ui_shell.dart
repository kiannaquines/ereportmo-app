import 'package:ereportmo_app/includes/app_fonts.dart';
import 'package:flutter/material.dart';

const Color kAppCanvas = Color(0xFFF3F1EF);
const Color kAppPanel = Colors.white;
const Color kAppMutedText = Color(0xFF9A918A);
const Color kAppLabelText = Color(0xFF524A43);
const Color kAppTitleText = Color(0xFF171412);
const Color kAppFieldFill = Color(0xFFFFFEFD);
const Color kAppFieldBorder = Color(0xFFF0E8E2);
const Color kAppAccent = Color(0xFFE65A34);
const Color kAppAccentSoft = Color(0xFFFFE5DE);

EdgeInsets appScreenPadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final isWide = width > 600;
  return EdgeInsets.symmetric(
    horizontal: isWide ? width * 0.18 : 22,
    vertical: isWide ? 28 : 18,
  );
}

Widget buildScreenPanel({
  required BuildContext context,
  required List<Widget> children,
}) {
  final width = MediaQuery.of(context).size.width;
  final isWide = width > 600;

  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 470),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          isWide ? 32 : 22,
          isWide ? 24 : 18,
          isWide ? 32 : 22,
          isWide ? 32 : 22,
        ),
        decoration: BoxDecoration(
          color: kAppPanel,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A2118).withValues(alpha: 0.08),
              blurRadius: 36,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    ),
  );
}

Widget buildProgressBar(BuildContext context, double value) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(999),
    child: LinearProgressIndicator(
      value: value,
      minHeight: 6,
      backgroundColor: const Color(0xFFF0E7E1),
      valueColor: const AlwaysStoppedAnimation<Color>(kAppAccent),
    ),
  );
}

Widget buildScreenHeader(
  BuildContext context, {
  required String title,
  required String subtitle,
  bool showBackButton = false,
}) {
  final width = MediaQuery.of(context).size.width;
  final isWide = width > 600;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          if (showBackButton && Navigator.canPop(context))
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => Navigator.maybePop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: kAppTitleText,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: isWide ? 38 : 24,
                height: 1.1,
                fontWeight: FontWeight.w800,
                color: kAppTitleText,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 16,
          height: 1.5,
          color: kAppMutedText,
        ),
      ),
    ],
  );
}

Widget buildSectionLabel(String label) {
  return Text(
    label,
    style: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: kAppLabelText,
    ),
  );
}

InputDecoration appInputDecoration(
  BuildContext context, {
  required String label,
  required IconData icon,
  Widget? trailing,
  String? hintText,
  bool alignLabelWithHint = false,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    alignLabelWithHint: alignLabelWithHint,
    labelStyle: GoogleFonts.inter(
      color: kAppMutedText,
      fontWeight: FontWeight.w500,
    ),
    hintStyle: GoogleFonts.inter(color: kAppMutedText),
    prefixIcon: Icon(icon, color: const Color(0xFFC0A89D)),
    suffixIcon: trailing,
    filled: true,
    fillColor: kAppFieldFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: kAppFieldBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: kAppFieldBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: kAppAccent, width: 1.6),
    ),
  );
}

BoxDecoration appSoftCardDecoration() {
  return BoxDecoration(
    color: kAppFieldFill,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: kAppFieldBorder),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF3A2118).withValues(alpha: 0.04),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
