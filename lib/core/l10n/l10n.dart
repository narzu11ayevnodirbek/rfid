import 'package:flutter/widgets.dart';
import 'package:rfid/core/l10n/generated/app_localizations.dart';

export 'package:rfid/core/l10n/generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
