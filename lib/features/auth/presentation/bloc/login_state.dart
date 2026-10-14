part of 'login_bloc.dart';

enum LoginStatus { editing, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.login = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.showValidationErrors = false,
    this.status = LoginStatus.editing,
    this.failure,
  });

  final String login;
  final String password;
  final bool isPasswordVisible;

  final bool showValidationErrors;
  final LoginStatus status;
  final Failure? failure;

  bool get isLoginMissing => login.trim().isEmpty;

  bool get isPasswordMissing => password.trim().isEmpty;

  bool get isFormFilled => !isLoginMissing && !isPasswordMissing;

  LoginState copyWith({
    String? login,
    String? password,
    bool? isPasswordVisible,
    bool? showValidationErrors,
    LoginStatus? status,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return LoginState(
      login: login ?? this.login,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      status: status ?? this.status,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        login,
        password,
        isPasswordVisible,
        showValidationErrors,
        status,
        failure,
      ];
}
