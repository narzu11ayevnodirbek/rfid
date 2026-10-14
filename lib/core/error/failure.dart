import 'package:equatable/equatable.dart';

/// Why an operation could not be completed.
///
/// Repositories return failures instead of throwing, blocs keep them in their
/// state and the UI turns them into text with `FailureLocalizer`. A failure
/// never carries text written by the app itself, so it stays translatable.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => const [];
}

/// The server could not be reached: offline, timeout or TLS error.
final class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// The session token is missing, expired or was rejected by the server.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({this.message});

  /// Text sent by the server, if any (for example "wrong password").
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// The server answered but refused the request.
final class ServerFailure extends Failure {
  const ServerFailure({this.message, this.statusCode});

  /// Text sent by the server. Shown to the user as is.
  final String? message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// The server answered with something the app could not understand.
final class ParsingFailure extends Failure {
  const ParsingFailure(this.details);

  /// Technical details for logs, not for the user.
  final String details;

  @override
  List<Object?> get props => [details];
}

enum RfidFailureReason {
  /// The device has no supported UHF module (phone, emulator).
  unavailable,

  /// The module exists but did not power on.
  initFailed,

  /// The reader refused a command (start, stop, power).
  commandFailed,
}

/// The RFID reader could not be used.
final class RfidFailure extends Failure {
  const RfidFailure(this.reason, {this.details});

  final RfidFailureReason reason;
  final String? details;

  @override
  List<Object?> get props => [reason, details];
}

/// Anything that does not fit the categories above.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(this.details);

  final String details;

  @override
  List<Object?> get props => [details];
}
