import 'package:flutter/widgets.dart';

/// Standardized spacing tokens (4dp base grid).
abstract final class AppSpacing {
  static const double none = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Common EdgeInsets presets
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets compactPadding = EdgeInsets.all(sm);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
}
