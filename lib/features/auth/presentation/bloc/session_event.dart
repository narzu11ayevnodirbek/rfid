part of 'session_bloc.dart';

sealed class SessionEvent {
  const SessionEvent();
}

final class SessionSignOutRequested extends SessionEvent {
  const SessionSignOutRequested();
}

/// The stored session changed (sign-in, sign-out or expiry).
final class _SessionStorageChanged extends SessionEvent {
  const _SessionStorageChanged();
}
