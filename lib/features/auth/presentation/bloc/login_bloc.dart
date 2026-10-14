import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/auth/domain/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

/// The login form.
///
/// On success it only starts the session; `SessionBloc` notices and the
/// router leaves the login screen by itself.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._repository) : super(const LoginState()) {
    on<LoginLoginChanged>(
      (event, emit) => emit(state.copyWith(login: event.value)),
    );
    on<LoginPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.value)),
    );
    on<LoginPasswordVisibilityToggled>(
      (event, emit) =>
          emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible)),
    );
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthRepository _repository;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status == LoginStatus.submitting) return;
    if (!state.isFormFilled) {
      emit(state.copyWith(showValidationErrors: true));
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, clearFailure: true));
    final result = await _repository.signIn(
      login: state.login.trim(),
      password: state.password.trim(),
    );
    switch (result) {
      case Success():
        emit(state.copyWith(status: LoginStatus.success));
      case Failed(:final failure):
        emit(state.copyWith(status: LoginStatus.failure, failure: failure));
    }
  }
}
