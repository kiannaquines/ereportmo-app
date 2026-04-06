import 'package:flutter/material.dart';

class GoogleFonts {
  static TextStyle inter({
    TextStyle? textStyle,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return (textStyle ?? const TextStyle()).copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle openSans({
    TextStyle? textStyle,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return (textStyle ?? const TextStyle()).copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextTheme interTextTheme(TextTheme textTheme) {
    return textTheme.copyWith(
      displayLarge: inter(textStyle: textTheme.displayLarge),
      displayMedium: inter(textStyle: textTheme.displayMedium),
      displaySmall: inter(textStyle: textTheme.displaySmall),
      headlineLarge: inter(textStyle: textTheme.headlineLarge),
      headlineMedium: inter(textStyle: textTheme.headlineMedium),
      headlineSmall: inter(textStyle: textTheme.headlineSmall),
      titleLarge: inter(textStyle: textTheme.titleLarge),
      titleMedium: inter(textStyle: textTheme.titleMedium),
      titleSmall: inter(textStyle: textTheme.titleSmall),
      bodyLarge: inter(textStyle: textTheme.bodyLarge),
      bodyMedium: inter(textStyle: textTheme.bodyMedium),
      bodySmall: inter(textStyle: textTheme.bodySmall),
      labelLarge: inter(textStyle: textTheme.labelLarge),
      labelMedium: inter(textStyle: textTheme.labelMedium),
      labelSmall: inter(textStyle: textTheme.labelSmall),
    );
  }
}
