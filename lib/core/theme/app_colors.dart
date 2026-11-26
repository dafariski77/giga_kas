import 'package:material_ui/material_ui.dart';

/// Restrained editorial color tokens designed for financial clarity.
abstract final class AppColors {
  // Primary brand accent: deep pine-emerald (calm, trustworthy, non-generic)
  static const Color primaryLight = Color(0xFF0F6B54);
  static const Color primaryDark = Color(0xFF34B391);

  // Neutral stone-paper surfaces (light) & charcoal-slate surfaces (dark)
  static const Color backgroundLight = Color(0xFFF7F6F2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSubtleLight = Color(0xFFF0EEE9);
  static const Color borderLight = Color(0xFFE4E1D8);
  static const Color inkLight = Color(0xFF14181F);
  static const Color mutedInkLight = Color(0xFF636973);

  static const Color backgroundDark = Color(0xFF101214);
  static const Color surfaceDark = Color(0xFF171A1E);
  static const Color surfaceSubtleDark = Color(0xFF20242A);
  static const Color borderDark = Color(0xFF2B3038);
  static const Color inkDark = Color(0xFFF2F3F5);
  static const Color mutedInkDark = Color(0xFF98A0AB);

  // Semantic accents (desaturated, legible)
  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFB45309);
  static const Color error = Color(0xFFB91C1C);
  static const Color taxIndigo = Color(0xFF3B5BDB);

  static ColorScheme lightScheme() => const ColorScheme(
        brightness: Brightness.light,
        primary: primaryLight,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFD8EFE8),
        onPrimaryContainer: Color(0xFF093E30),
        secondary: Color(0xFF334155),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFE6EAF0),
        onSecondaryContainer: Color(0xFF1E293B),
        tertiary: taxIndigo,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFE4E9FC),
        onTertiaryContainer: Color(0xFF1E328A),
        error: error,
        onError: Colors.white,
        errorContainer: Color(0xFFFCE8E8),
        onErrorContainer: Color(0xFF7F1D1D),
        surface: surfaceLight,
        onSurface: inkLight,
        surfaceContainerLowest: surfaceLight,
        surfaceContainerLow: backgroundLight,
        surfaceContainer: surfaceSubtleLight,
        surfaceContainerHigh: Color(0xFFE8E5DD),
        onSurfaceVariant: mutedInkLight,
        outline: Color(0xFFC9C4B8),
        outlineVariant: borderLight,
      );

  static ColorScheme darkScheme() => const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: Color(0xFF05291F),
        primaryContainer: Color(0xFF0E4436),
        onPrimaryContainer: Color(0xFFB3EBDA),
        secondary: Color(0xFF94A3B8),
        onSecondary: Color(0xFF0F172A),
        secondaryContainer: Color(0xFF262D38),
        onSecondaryContainer: Color(0xFFE2E8F0),
        tertiary: Color(0xFF748FFC),
        onTertiary: Color(0xFF111C4E),
        tertiaryContainer: Color(0xFF22306E),
        onTertiaryContainer: Color(0xFFDBE4FF),
        error: Color(0xFFF87171),
        onError: Color(0xFF450A0A),
        errorContainer: Color(0xFF5C1919),
        onErrorContainer: Color(0xFFFEE2E2),
        surface: surfaceDark,
        onSurface: inkDark,
        surfaceContainerLowest: backgroundDark,
        surfaceContainerLow: backgroundDark,
        surfaceContainer: surfaceSubtleDark,
        surfaceContainerHigh: Color(0xFF292E36),
        onSurfaceVariant: mutedInkDark,
        outline: Color(0xFF3E4550),
        outlineVariant: borderDark,
      );
}
