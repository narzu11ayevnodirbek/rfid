part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();
}

final class InitialEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

final class AppThemeSwitch extends AppEvent {
  const AppThemeSwitch({this.theme, required this.themeMode});

  final ThemeData? theme;
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [theme, themeMode];
}

final class AppChangeLocale extends AppEvent {
  const AppChangeLocale(this.appLocale);

  final String appLocale;

  @override
  List<Object?> get props => [appLocale];
}
