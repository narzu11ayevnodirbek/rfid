import 'package:flutter/widgets.dart';

/// Distances between elements. Use these instead of literal numbers so the
/// whole app keeps one rhythm.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Padding around the content of a page.
  static const EdgeInsets page = EdgeInsets.all(lg);

  /// Padding around a scrolling list of cards.
  static const EdgeInsets list = EdgeInsets.fromLTRB(lg, sm, lg, xl);
}

/// Corner radii.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;
}

/// Fixed sizes of interactive elements.
abstract final class AppSizes {
  /// Large enough to hit with a glove on a handheld terminal.
  static const double buttonHeight = 52;
  static const double iconBadge = 40;
}
