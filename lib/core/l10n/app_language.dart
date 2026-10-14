import 'dart:ui';

enum AppLanguage {
  russian('ru', 'Русский'),
  uzbek('uz', 'O‘zbekcha');

  const AppLanguage(this.code, this.nativeName);

  final String code;

  final String nativeName;

  Locale get locale => Locale(code);

  static const AppLanguage fallback = AppLanguage.russian;

  static AppLanguage fromCode(String? code) => AppLanguage.values.firstWhere(
        (language) => language.code == code,
        orElse: () => fallback,
      );
}
