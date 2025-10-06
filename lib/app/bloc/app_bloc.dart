import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rf_id_test/core/extention/extension.dart';
import 'package:rf_id_test/core/theme/themes.dart';
import 'package:rf_id_test/injector_container.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this.networkInfo)
      : super(AppState(
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          appLocale: localSource.getLocale,
          themeMode: localSource.getTheme,
        )) {
    on<InitialEvent>(_initialEvent);
    on<AppThemeSwitch>(_switchThemeHandler);
    on<AppChangeLocale>(_changeLocale);
  }

  final InternetConnection networkInfo;

  FutureOr<void> _initialEvent(
    InitialEvent event,
    Emitter<AppState> emit,
  ) async {
    await emit.onEach(
      networkInfo.onStatusChange,
      onData: (status) {
        emit(state.copyWith(isConnected: status == InternetStatus.connected));
      },
    );
  }

  FutureOr<void> _switchThemeHandler(
    AppThemeSwitch event,
    Emitter<AppState> emit,
  ) async {
    await localSource.setTheme(event.themeMode.themeModeText);
    emit(
      state.copyWith(
        lightTheme: event.themeMode == ThemeMode.light ? event.theme : null,
        darkTheme: event.themeMode == ThemeMode.dark ? event.theme : null,
        themeMode: event.themeMode,
      ),
    );
  }

  FutureOr<void> _changeLocale(
    AppChangeLocale event,
    Emitter<AppState> emit,
  ) async {
    await localSource.setLocale(event.appLocale);
    emit(state.copyWith(appLocale: event.appLocale));
  }
}
