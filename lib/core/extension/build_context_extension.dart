part of 'extension.dart';

extension BuildContextExt on BuildContext {
  String translate(String key) => AppLocalizations.of(this).translate(key);

  Locale get locale => Localizations.localeOf(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;

  ThemeTextStyles get textStyle => Theme.of(this).extension<ThemeTextStyles>()!;

  GoRouter get goRouter => GoRouter.of(this);

  AppLocalizations get localization => AppLocalizations.of(this);

  void unfocus() {
    final focus = FocusScope.of(this);
    if (focus.hasFocus) focus.unfocus();
  }
}
