import 'package:flutter/widgets.dart';
import 'package:rfid/core/l10n/generated/app_localizations.dart';

export 'package:rfid/core/l10n/generated/app_localizations.dart';

/// `context.l10n.someText` instead of `AppLocalizations.of(context).someText`.
///
/// Texts live in `lib/core/l10n/arb/app_ru.arb` (template) and
/// `app_uz.arb`; `flutter gen-l10n` regenerates the Dart classes.
extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
