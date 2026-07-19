import 'package:dio/dio.dart';

class ServerException implements Exception {
  ServerException({
    required this.message,
    required this.statusCode,
    this.response,
    this.stackTrace,
  });

  ServerException.fromResponse(Response response)
      : message = response.data['error'] ?? 'Unknown error',
        statusCode = response.statusCode,
        response = response.data,
        stackTrace = null;

  final String? message;
  final int? statusCode;
  final dynamic response;
  final StackTrace? stackTrace;
}

class NoInternetException implements Exception {}

class CacheException implements Exception {
  CacheException({required this.message});

  final String message;

  @override
  String toString() => message;
}
