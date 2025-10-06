part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class InitialAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

final class OnAuthenticateEvent extends AuthEvent {
  const OnAuthenticateEvent(this.params);

  final AuthParams params;

  @override
  List<Object?> get props => [params];
}
