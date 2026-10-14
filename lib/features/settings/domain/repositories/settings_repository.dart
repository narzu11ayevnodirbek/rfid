import 'package:rfid/core/l10n/app_language.dart';

abstract interface class SettingsRepository {
  AppLanguage readLanguage();

  Future<void> saveLanguage(AppLanguage language);
}
