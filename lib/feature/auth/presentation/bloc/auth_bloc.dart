import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rf_id_test/core/enums/status_enums.dart';
import 'package:rf_id_test/core/error/exceptions.dart';
import 'package:rf_id_test/feature/auth/domain/repository/auth_params.dart';
import 'package:rf_id_test/feature/auth/domain/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState()) {
    on<InitialAuthEvent>(_initialAuthEvent);
    on<OnAuthenticateEvent>(_onAuthenticateEvent);
  }

  final AuthRepository _repository;

  FutureOr<void> _initialAuthEvent(
    InitialAuthEvent event,
    Emitter<AuthState> emit,
  ) async {}

  FutureOr<void> _onAuthenticateEvent(
    OnAuthenticateEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PageStatus.loading));
      final result = await _repository.authenticate(event.params);
      emit(state.copyWith(
        status: PageStatus.success,
        message: result?.username ?? 'Unknown user',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PageStatus.error,
        message: e is ServerException ? e.message : e.toString(),
      ));
    }
  }
}
