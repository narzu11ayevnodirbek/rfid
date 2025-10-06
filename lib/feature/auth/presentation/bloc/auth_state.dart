part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = PageStatus.initial,
    this.message = '',
  });

  final PageStatus status;
  final String message;

  AuthState copyWith({
    final PageStatus? status,
    final String? message,
  }) =>
      AuthState(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [status, message];
}
