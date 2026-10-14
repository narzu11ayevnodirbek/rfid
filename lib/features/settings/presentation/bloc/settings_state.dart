part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.language});

  final AppLanguage language;

  SettingsState copyWith({AppLanguage? language}) =>
      SettingsState(language: language ?? this.language);

  @override
  List<Object?> get props => [language];
}
