part of 'themes.dart';

final ThemeData darkTheme = appTheme.copyWith(
  extensions: <ThemeExtension<dynamic>>[
    ThemeTextStyles.dark,
    ThemeColors.dark,
  ],
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  dialogBackgroundColor: darkColorScheme.surface,
  scaffoldBackgroundColor: darkColorScheme.surface,
  cardColor: darkColorScheme.surface,
  canvasColor: darkColorScheme.surfaceContainer,
  hintColor: ThemeColors.dark.disabledBorder,
  dialogTheme: DialogThemeData(
    backgroundColor: darkColorScheme.onPrimary,
    surfaceTintColor: darkColorScheme.onPrimary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: darkColorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: kBorderRadius8,
    ),
    titleTextStyle: ThemeTextStyles.dark.regularBody,
  ),
  iconTheme: IconThemeData(color: darkColorScheme.onSurface),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: darkColorScheme.onSurface,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => lightColorScheme.onPrimary,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return darkColorScheme.primary;
        },
      ),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.dark.buttonStyle),
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
    backgroundColor: darkColorScheme.surfaceContainer,
    surfaceTintColor: darkColorScheme.surfaceContainer,
    dragHandleColor: darkColorScheme.onSurface,
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
    selectedItemColor: darkColorScheme.primary,
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
      (states) => ThemeTextStyles.dark.appBarTitle,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    toolbarTextStyle: ThemeTextStyles.dark.appBarTitle,
    backgroundColor: darkColorScheme.surfaceContainer,
    surfaceTintColor: darkColorScheme.surfaceContainer,
    shadowColor: const Color(0x33FFFFFF),
    titleTextStyle: TextStyle(
      color: darkColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      // ios
      statusBarBrightness: Brightness.dark,
      // android
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(color: darkColorScheme.onSurface),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(12),
      ),
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontWeight: FontWeight.w400,
      fontSize: 34,
    ),

    /// text field title style
    titleMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),
    titleSmall: TextStyle(
      color: darkColorScheme.onSurface,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),

    /// list tile title style
    bodyLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),

    /// list tile subtitle style
    bodyMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    bodySmall: TextStyle(
      color: darkColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
    displayLarge: TextStyle(
      color: darkColorScheme.onSurface,
    ),
    displayMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    displaySmall: TextStyle(
      color: darkColorScheme.onSurface,
    ),
  ),
);
