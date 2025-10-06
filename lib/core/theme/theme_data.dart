part of 'themes.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  applyElevationOverlayColor: true,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
    },
  ),
  fontFamily: 'Oxygen',
  splashFactory: Platform.isAndroid ? InkRipple.splashFactory : NoSplash.splashFactory,
  visualDensity: VisualDensity.standard,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero)),
  ),
  dividerTheme: const DividerThemeData(thickness: 1),
);
