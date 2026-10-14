import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// Pumps [page] with the app's theme and Russian texts.
  Future<void> pumpApp(Widget page) async {
    await pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: page,
      ),
    );
    await pump();
  }
}
