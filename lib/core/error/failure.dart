import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.response});

  final dynamic response;

  @override
  List<Object?> get props => [message, response];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({super.message = 'No internet connection'});

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});

  @override
  List<Object?> get props => [message];
}
