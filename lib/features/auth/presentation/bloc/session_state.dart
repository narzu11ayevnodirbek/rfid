part of 'session_bloc.dart';

class SessionState extends Equatable {
  const SessionState({
    required this.isAuthenticated,
    this.user,
    this.endReason,
  });

  factory SessionState.fromStorage(SessionStorage storage) => SessionState(
        isAuthenticated: storage.isAuthenticated,
        user: storage.user,
        endReason: storage.lastEndReason,
      );

  final bool isAuthenticated;
  final User? user;

  /// Why the previous session ended; the login screen explains an expiry.
  final SessionEndReason? endReason;

  @override
  List<Object?> get props => [isAuthenticated, user, endReason];
}
