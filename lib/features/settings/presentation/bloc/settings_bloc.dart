import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/app_language.dart';
import 'package:rfid/features/settings/domain/repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._repository)
      : super(SettingsState(language: _repository.readLanguage())) {
    on<SettingsLanguageChanged>(_onLanguageChanged);
  }

  final SettingsRepository _repository;

  Future<void> _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(language: event.language));
    await _repository.saveLanguage(event.language);
  }
}
