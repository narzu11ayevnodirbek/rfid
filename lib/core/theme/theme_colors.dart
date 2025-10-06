part of 'themes.dart';

ColorScheme get lightColorScheme => const ColorScheme.light(
      primary: Color(0xff00495f),
      surfaceTint: Color(0xff116682),
      primaryContainer: Color(0xff337d99),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff31464f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff637882),
      onSecondaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fafd),
      onSurface: Color(0xff171c1f),
      onSurfaceVariant: Color(0xff3c4448),
      outline: Color(0xff70787d),
      outlineVariant: Color(0xffc0c8cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xff8bd0ef),
      surfaceContainer: Color(0xffeaeef2),
    );

ColorScheme get darkColorScheme => const ColorScheme.dark(
      primary: Color(0xff00708a),
      surfaceTint: Color(0xff16809b),
      primaryContainer: Color(0xff2892ac),
      onPrimaryContainer: Color(0xffe6faff),
      secondary: Color(0xff3f5e6a),
      onSecondary: Color(0xfff0f7fa),
      secondaryContainer: Color(0xFFB3E5FC),
      onSecondaryContainer: Color(0xFF000000),
      error: Color(0xffff5449),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1417),
      onSurface: Color(0xffdfe3e7),
      onSurfaceVariant: Color(0xFFFFFFFF),
      outline: Color(0xff8a9297),
      outlineVariant: Color(0xff40484c),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFD7CCC8),
      inversePrimary: Color(0xFF007AFF),
      surfaceContainer: Color(0xff1b2023),
    );

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.green,
    required this.productPrimary,
    required this.lightGray,
    required this.placeholder,
    required this.whiteSmoke,
    required this.gray19,
    required this.gray,
    required this.disabledBorder,
    required this.iconColor,
  });

  final Color green;
  final Color productPrimary;
  final Color lightGray;
  final Color placeholder;
  final Color whiteSmoke;
  final Color gray19;
  final Color gray;
  final Color disabledBorder;
  final Color iconColor;

  static const ThemeColors light = ThemeColors(
    green: Color(0xFF28C76F),
    productPrimary: Color(0xFF453746),
    lightGray: Color(0xFFB0B0B0),
    placeholder: Color(0xFFBDBDBD),
    whiteSmoke: Color(0xFFF1F1F1),
    gray19: Color(0xFF303030),
    gray: Color(0xFF505050),
    disabledBorder: Color(0xFFD8D6DE),
    iconColor: Color(0xFF7A7A7A),
  );

  static const ThemeColors dark = ThemeColors(
    green: Color(0xFF28C76F),
    productPrimary: Color(0xFF453746),
    lightGray: Color(0xFFB0B0B0),
    placeholder: Color(0xFFBDBDBD),
    whiteSmoke: Color(0xFFF1F1F1),
    gray19: Color(0xFF303030),
    gray: Color(0xFF505050),
    disabledBorder: Color(0xFF404656),
    iconColor: Color(0xFFB4B7BD),
  );

  @override
  ThemeExtension<ThemeColors> copyWith({
    final Color? green,
    final Color? productPrimary,
    final Color? lightGray,
    final Color? placeholder,
    final Color? darkCerulean,
    final Color? whiteSmoke,
    final Color? gray19,
    final Color? gray,
    final Color? disabledBorder,
    final Color? iconColor,
  }) =>
      ThemeColors(
        green: green ?? this.green,
        productPrimary: productPrimary ?? this.productPrimary,
        lightGray: lightGray ?? this.lightGray,
        placeholder: placeholder ?? this.placeholder,
        whiteSmoke: whiteSmoke ?? this.whiteSmoke,
        gray19: gray19 ?? this.gray19,
        gray: gray ?? this.gray,
        disabledBorder: disabledBorder ?? this.disabledBorder,
        iconColor: iconColor ?? this.iconColor,
      );

  @override
  ThemeExtension<ThemeColors> lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) {
      return this;
    }
    return ThemeColors(
      green: Color.lerp(green, other.green, t)!,
      productPrimary: Color.lerp(productPrimary, other.productPrimary, t)!,
      lightGray: Color.lerp(lightGray, other.lightGray, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      whiteSmoke: Color.lerp(whiteSmoke, other.whiteSmoke, t)!,
      gray19: Color.lerp(gray19, other.gray19, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      disabledBorder: Color.lerp(disabledBorder, other.disabledBorder, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
    );
  }
}

ColorScheme get _darkHighContrastScheme => const ColorScheme.highContrastDark(
      primary: Color(0xFFFAFAFA),
      surfaceTint: Color(0xFF4CAF50),
      primaryContainer: Color(0xFF1982C4),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFFFAFAFA),
      secondaryContainer: Color(0xFFE0F7FA),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFFFFE082),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFFC107),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFFFD6D6),
      errorContainer: Color(0xFFFF6F00),
      onErrorContainer: Color(0xFF000000),
      surface: Color(0xFFD6D6D6),
      onSurfaceVariant: Color(0xFFFAFAFA),
      outline: Color(0xFFB0BEC5),
      outlineVariant: Color(0xFFB0BEC5),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFD7CCC8),
      inversePrimary: Color(0xFF007AFF),
      primaryFixed: Color(0xFF90CAF9),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFF1982C4),
      onPrimaryFixedVariant: Color(0xFFB3E5FC),
      secondaryFixed: Color(0xFFFFCC80),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFE0F7FA),
      onSecondaryFixedVariant: Color(0xFFD1C4E9),
      tertiaryFixed: Color(0xFFFFE082),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFFFFC107),
      onTertiaryFixedVariant: Color(0xFF607D8B),
      surfaceDim: Color(0xFFD6D6D6),
      surfaceBright: Color(0xFFECEFF1),
      surfaceContainerLowest: Color(0xFFB0BEC5),
      surfaceContainerLow: Color(0xFFB3E5FC),
      surfaceContainer: Color(0xFF90CAF9),
      surfaceContainerHigh: Color(0xFF0288D1),
      surfaceContainerHighest: Color(0xFF01579B),
    );

ColorScheme get _lightHighContrastScheme => const ColorScheme.highContrastLight(
      primary: Color(0xff002633),
      surfaceTint: Color(0xff116682),
      primaryContainer: Color(0xff00495f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff10252e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff31464f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff201f3d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff413f60),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fafd),
      onSurfaceVariant: Color(0xff1d2529),
      outline: Color(0xff3c4448),
      outlineVariant: Color(0xff3c4448),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xffd5f0ff),
      primaryFixed: Color(0xff00495f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003141),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff31464f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1b2f39),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff413f60),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2b2949),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd6dbde),
      surfaceBright: Color(0xfff6fafd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f8),
      surfaceContainer: Color(0xffeaeef2),
      surfaceContainerHigh: Color(0xffe4e9ec),
      surfaceContainerHighest: Color(0xffdfe3e7),
    );

// /// A set of colors for the entire app.
// const ColorScheme colorLightScheme = ColorScheme.light(
//   primary: Color(0xFF0B7EC8),
//   onPrimary: Color(0xFFF8FDFF),
//   surface: Color(0xFFF8F8F8),
//   error: Color(0xFFEA2A42),
//   shadow: Color(0x33121212),
// );
//
// ///
// const ColorScheme colorDarkScheme = ColorScheme.dark(
//   primary: Color(0xFF246BFD),
//   onPrimary: Color(0xFF1E2330),
//   surface: Color(0xFF161E31),
//   error: Color(0xFFEA2A42),
//   shadow: Color(0x33FFFFFF),
// );

// ColorScheme darkScheme() => const ColorScheme(
// brightness: Brightness.dark,
// primary: Color(4287353071),
// surfaceTint: Color(4287353071),
// onPrimary: Color(4278203718),
// primaryContainer: Color(4278209892),
// onPrimaryContainer: Color(4290636287),
// secondary: Color(4290038486),
// onSecondary: Color(4280234812),
// secondaryContainer: Color(4281682515),
// onSecondaryContainer: Color(4291880690),
// tertiary: Color(4291216106),
// onTertiary: Color(4281216333),
// tertiaryContainer: Color(4282729316),
// onTertiaryContainer: Color(4293124095),
// error: Color(4294948011),
// onError: Color(4285071365),
// errorContainer: Color(4287823882),
// onErrorContainer: Color(4294957782),
// background: Color(4279178263),
// onBackground: Color(4292862951),
// surfaceVariant: Color(4282402892),
// onSurfaceVariant: Color(4290824397),
// outline: Color(4287271575),
// outlineVariant: Color(4282402892),
// shadow: Color(4278190080),
// scrim: Color(4278190080),
// inverseSurface: Color(4292862951),
// inverseOnSurface: Color(4281086260),
// inversePrimary: Color(4279330434),
// primaryFixed: Color(4290636287),
// onPrimaryFixed: Color(4278198058),
// primaryFixedDim: Color(4287353071),
// onPrimaryFixedVariant: Color(4278209892),
// secondaryFixed: Color(4291880690),
// onSecondaryFixed: Color(4278722087),
// secondaryFixedDim: Color(4290038486),
// onSecondaryFixedVariant: Color(4281682515),
// tertiaryFixed: Color(4293124095),
// onTertiaryFixed: Color(4279834678),
// tertiaryFixedDim: Color(4291216106),
// onTertiaryFixedVariant: Color(4282729316),
// surfaceDim: Color(4279178263),
// surfaceBright: Color(4281678397),
// surfaceContainerLowest: Color(4278849297),
// surfaceContainerLow: Color(4279704607),
// surfaceContainer: ,
// surfaceContainerHigh: Color(4280691501),
// surfaceContainerHighest: Color(4281349432),
// );
