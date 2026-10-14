part of 'settings_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsLanguageChanged extends SettingsEvent {
  const SettingsLanguageChanged(this.language);

  final AppLanguage language;
}
