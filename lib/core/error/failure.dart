import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => const [];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

final class ParsingFailure extends Failure {
  const ParsingFailure(this.details);

  final String details;

  @override
  List<Object?> get props => [details];
}

enum RfidFailureReason {
  unavailable,
  initFailed,
  commandFailed,
}

final class RfidFailure extends Failure {
  const RfidFailure(this.reason, {this.details});

  final RfidFailureReason reason;
  final String? details;

  @override
  List<Object?> get props => [reason, details];
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(this.details);

  final String details;

  @override
  List<Object?> get props => [details];
}
