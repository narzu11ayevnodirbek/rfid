part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();
}

final class LoginLoginChanged extends LoginEvent {
  const LoginLoginChanged(this.value);

  final String value;
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.value);

  final String value;
}

final class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
