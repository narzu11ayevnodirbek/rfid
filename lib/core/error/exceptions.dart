import 'package:rfid/core/error/failure.dart';

/// Thrown by data sources when the server answers `success: false`.
class ApiException implements Exception {
  const ApiException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode, $message)';
}

/// Thrown by the RFID reader when the hardware cannot do what was asked.
class RfidException implements Exception {
  const RfidException(this.reason, {this.details});

  final RfidFailureReason reason;
  final String? details;

  @override
  String toString() => 'RfidException($reason, $details)';
}
