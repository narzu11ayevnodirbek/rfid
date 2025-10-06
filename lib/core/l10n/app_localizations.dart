import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';

final class AppLocalizations {
  AppLocalizations._();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations) ?? instance;

  static AppLocalizations get instance => AppLocalizations._();
  static final ValueNotifier<Map<String, dynamic>> localizedValues = ValueNotifier({});

  String translate(String key) {
    if (localizedValues.value.isNotEmpty) {
      return localizedValues.value[key] ?? '* $key';
    }
    return '';
  }

  static Future<AppLocalizations> load(Locale locale) async {
    final String jsonContent = await rootBundle.loadString(
      'assets/locale/${locale.languageCode}-${locale.countryCode}.json',
    );
    localizedValues.value = jsonDecode(jsonContent);
    return instance;
  }

  static const Iterable<LocalizationsDelegate> localizationsDelegates = [
    TranslationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ru', 'RU'),
    Locale('uz', 'UZ'),
  ];
}

class TranslationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['uz', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => await SynchronousFuture<AppLocalizations>(
        await AppLocalizations.load(locale),
      );

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
