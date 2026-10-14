import 'package:flutter/material.dart';

/// Brand colour and the colour schemes derived from it.
abstract final class AppColors {
  /// The teal of the legacy app, kept as the brand colour.
  static const Color brand = Color(0xFF00495F);

  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: brand,
  ).copyWith(primary: brand);

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: brand,
    brightness: Brightness.dark,
  );
}

/// Meaning of a coloured element: found, missing, warning, ...
enum StatusTone { neutral, info, success, warning, danger }

/// Colours for [StatusTone], available as `context.statusColors`.
///
/// Material's `ColorScheme` has no "success" or "warning", so they live in
/// this theme extension next to it.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({required this.foregrounds, required this.backgrounds});

  static const StatusColors light = StatusColors(
    foregrounds: {
      StatusTone.neutral: Color(0xFF4B5A63),
      StatusTone.info: Color(0xFF0B5CAD),
      StatusTone.success: Color(0xFF1B7A3D),
      StatusTone.warning: Color(0xFF8A5A00),
      StatusTone.danger: Color(0xFFB3261E),
    },
    backgrounds: {
      StatusTone.neutral: Color(0xFFE6ECEF),
      StatusTone.info: Color(0xFFDCEBFB),
      StatusTone.success: Color(0xFFDDF3E4),
      StatusTone.warning: Color(0xFFFFEFD2),
      StatusTone.danger: Color(0xFFFCE4E2),
    },
  );

  static const StatusColors dark = StatusColors(
    foregrounds: {
      StatusTone.neutral: Color(0xFFC4CDD2),
      StatusTone.info: Color(0xFF9CCBFF),
      StatusTone.success: Color(0xFF8FD8A6),
      StatusTone.warning: Color(0xFFF5C26B),
      StatusTone.danger: Color(0xFFFFB4AB),
    },
    backgrounds: {
      StatusTone.neutral: Color(0xFF2A3338),
      StatusTone.info: Color(0xFF12324F),
      StatusTone.success: Color(0xFF133823),
      StatusTone.warning: Color(0xFF3D2C07),
      StatusTone.danger: Color(0xFF4A1612),
    },
  );

  final Map<StatusTone, Color> foregrounds;
  final Map<StatusTone, Color> backgrounds;

  /// Text and icon colour for [tone].
  Color foreground(StatusTone tone) => foregrounds[tone]!;

  /// Fill colour behind [foreground].
  Color background(StatusTone tone) => backgrounds[tone]!;

  @override
  StatusColors copyWith({
    Map<StatusTone, Color>? foregrounds,
    Map<StatusTone, Color>? backgrounds,
  }) {
    return StatusColors(
      foregrounds: foregrounds ?? this.foregrounds,
      backgrounds: backgrounds ?? this.backgrounds,
    );
  }

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      foregrounds: {
        for (final tone in StatusTone.values)
          tone: Color.lerp(foreground(tone), other.foreground(tone), t)!,
      },
      backgrounds: {
        for (final tone in StatusTone.values)
          tone: Color.lerp(background(tone), other.background(tone), t)!,
      },
    );
  }
}

extension StatusColorsContext on BuildContext {
  StatusColors get statusColors => Theme.of(this).extension<StatusColors>()!;
}
