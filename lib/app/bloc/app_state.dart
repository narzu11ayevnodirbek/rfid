part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.appLocale,
    this.lightTheme,
    this.darkTheme,
    this.themeMode,
    this.update = false,
    this.isConnected = true,
  });

  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final String? appLocale;
  final bool update;
  final bool isConnected;

  AppState copyWith({
    final ThemeData? lightTheme,
    final ThemeData? darkTheme,
    final ThemeMode? themeMode,
    final String? appLocale,
    final bool? update,
    final bool? isConnected,
    final bool? isConnectionSheetShown,
  }) =>
      AppState(
        lightTheme: lightTheme ?? this.lightTheme,
        darkTheme: darkTheme ?? this.darkTheme,
        themeMode: themeMode ?? this.themeMode,
        appLocale: appLocale ?? this.appLocale,
        update: update ?? this.update,
        isConnected: isConnected ?? this.isConnected,
      );

  @override
  List<Object?> get props => [
        lightTheme,
        darkTheme,
        themeMode,
        appLocale,
        update,
        isConnected,
      ];
}
