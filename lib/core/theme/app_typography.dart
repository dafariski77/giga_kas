import 'package:material_ui/material_ui.dart';

/// Standardized font size tokens.
abstract final class AppFontSize {
  static const double xs = 11;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 18;
  static const double xxl = 22;
  static const double displaySm = 28;
  static const double displayMd = 32;
  static const double displayLg = 36;
}

/// Editorial typography with restrained weights and tabular numeric support.
abstract final class AppTypography {
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  static TextTheme textTheme(ColorScheme colorScheme) {
    final baseColor = colorScheme.onSurface;
    final mutedColor = colorScheme.onSurfaceVariant;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppFontSize.displayLg,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        height: 1.15,
        color: baseColor,
        fontFeatures: tabularFigures,
      ),
      displayMedium: TextStyle(
        fontSize: AppFontSize.displayMd,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        height: 1.18,
        color: baseColor,
        fontFeatures: tabularFigures,
      ),
      displaySmall: TextStyle(
        fontSize: AppFontSize.displaySm,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.22,
        color: baseColor,
        fontFeatures: tabularFigures,
      ),
      headlineMedium: TextStyle(
        fontSize: AppFontSize.xxl,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.28,
        color: baseColor,
        fontFeatures: tabularFigures,
      ),
      titleLarge: TextStyle(
        fontSize: AppFontSize.xl,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.32,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: AppFontSize.lg,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.38,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: AppFontSize.lg,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: mutedColor,
      ),
      labelLarge: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: mutedColor,
      ),
      labelSmall: TextStyle(
        fontSize: AppFontSize.xs,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.7,
        color: mutedColor,
      ),
    );
  }
}
