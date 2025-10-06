part of 'themes.dart';

final ThemeData lightTheme = appTheme.copyWith(
  extensions: <ThemeExtension<dynamic>>[
    ThemeTextStyles.light,
    ThemeColors.light,
  ],
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  dialogBackgroundColor: lightColorScheme.surface,
  scaffoldBackgroundColor: lightColorScheme.surface,
  cardColor: lightColorScheme.surface,
  canvasColor: lightColorScheme.surfaceContainer,
  dialogTheme: const DialogThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: lightColorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: kBorderRadius8,
    ),
    titleTextStyle: ThemeTextStyles.light.regularBody,
  ),
  iconTheme: IconThemeData(color: lightColorScheme.onSurface),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return lightColorScheme.primary;
          }
          return lightColorScheme.onPrimary;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return lightColorScheme.primary.withValues(alpha: 0.2);
          }
          return lightColorScheme.primary;
        },
      ),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.light.buttonStyle),
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      fixedSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(),
  bottomSheetTheme: BottomSheetThemeData(
    elevation: 0,
    showDragHandle: true,
    backgroundColor: lightColorScheme.surfaceContainer,
    surfaceTintColor: lightColorScheme.surfaceContainer,
    dragHandleColor: lightColorScheme.onSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    selectedLabelStyle: const TextStyle(fontSize: 12),
    unselectedLabelStyle: const TextStyle(fontSize: 12),
    unselectedItemColor: const Color(0xffA0A9B6),
    selectedItemColor: lightColorScheme.primary,
    elevation: 2,
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: Color(0xff111126),
    unselectedLabelColor: Color(0xff111126),
    dividerColor: Colors.transparent,
    overlayColor: WidgetStatePropertyAll(Colors.transparent),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    indicator: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,
    backgroundColor: Colors.white,
    height: kToolbarHeight,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (states) => const IconThemeData(
        color: Colors.black,
      ),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
      (states) => ThemeTextStyles.light.appBarTitle,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      // ios
      statusBarBrightness: Brightness.light,
      // android
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(color: lightColorScheme.onSurface),
    shadowColor: const Color(0x33000000),
    titleTextStyle: TextStyle(
      color: lightColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    toolbarTextStyle: ThemeTextStyles.light.appBarTitle,
    backgroundColor: lightColorScheme.surfaceContainer,
    surfaceTintColor: lightColorScheme.surfaceContainer,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: lightColorScheme.onSurface,
      fontWeight: FontWeight.w400,
      fontSize: 34,
    ),

    /// text field title style
    titleMedium: TextStyle(
      color: lightColorScheme.onSurface,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),
    titleSmall: TextStyle(
      color: lightColorScheme.onSurface,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),

    /// list tile title style
    bodyLarge: TextStyle(
      color: lightColorScheme.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),

    /// list tile subtitle style
    bodyMedium: TextStyle(
      color: lightColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    bodySmall: TextStyle(
      color: lightColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
    displayLarge: TextStyle(
      color: lightColorScheme.onSurface,
    ),
    displayMedium: TextStyle(
      color: lightColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    displaySmall: TextStyle(
      color: lightColorScheme.onSurface,
    ),
  ),
);
