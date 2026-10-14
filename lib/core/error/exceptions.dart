import 'package:rfid/core/error/failure.dart';

class ApiException implements Exception {
  const ApiException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode, $message)';
}

class RfidException implements Exception {
  const RfidException(this.reason, {this.details});

  final RfidFailureReason reason;
  final String? details;

  @override
  String toString() => 'RfidException($reason, $details)';
}
