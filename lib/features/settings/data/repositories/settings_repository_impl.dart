import 'package:rfid/core/l10n/app_language.dart';
import 'package:rfid/core/storage/key_value_store.dart';
import 'package:rfid/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._store);

  static const String _languageKey = 'app_language';

  final KeyValueStore _store;

  @override
  AppLanguage readLanguage() =>
      AppLanguage.fromCode(_store.readString(_languageKey));

  @override
  Future<void> saveLanguage(AppLanguage language) =>
      _store.writeString(_languageKey, language.code);
}
