import 'dart:ui';

/// Languages the app is translated to, in the order shown in Settings.
enum AppLanguage {
  russian('ru', 'Русский'),
  uzbek('uz', 'Oʻzbekcha');

  const AppLanguage(this.code, this.nativeName);

  /// Language code stored in settings and used for the [Locale].
  final String code;

  /// Name written in the language itself, so anyone can find their own.
  final String nativeName;

  Locale get locale => Locale(code);

  static const AppLanguage fallback = AppLanguage.russian;

  static AppLanguage fromCode(String? code) => AppLanguage.values.firstWhere(
        (language) => language.code == code,
        orElse: () => fallback,
      );
}
