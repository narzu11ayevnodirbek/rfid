import 'package:rfid/core/l10n/app_language.dart';

/// User preferences stored on the device.
abstract interface class SettingsRepository {
  AppLanguage readLanguage();

  Future<void> saveLanguage(AppLanguage language);
}
