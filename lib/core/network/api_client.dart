import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rfid/core/config/app_config.dart';
import 'package:rfid/core/network/api_envelope_parser.dart';
import 'package:rfid/core/network/auth_token_interceptor.dart';
import 'package:rfid/core/network/json_reader.dart';

/// The single entry point to the backend.
///
/// Data sources call [get] and [post] with a path from `ApiEndpoints` and get
/// back the decoded response body, already checked for `success: true`.
/// Failures are thrown (`DioException`, `ApiException`, `FormatException`) and
/// turned into `Failure`s by `guard` in the repository layer.
class ApiClient {
  ApiClient(this._dio);

  /// Builds the client used by the app.
  factory ApiClient.create({
    required String? Function() readToken,
    required void Function(String rejectedToken) onUnauthorized,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        contentType: Headers.jsonContentType,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.receiveTimeout,
      ),
    );
    dio.interceptors.add(
      AuthTokenInterceptor(
        readToken: readToken,
        onUnauthorized: onUnauthorized,
      ),
    );
    // Request logs contain tokens and passwords, so never in release builds.
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(requestBody: true, compact: true, maxWidth: 100),
      );
    }
    return ApiClient(dio);
  }

  final Dio _dio;

  Future<JsonMap> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<Object?>(path, queryParameters: query);
    return ApiEnvelopeParser.parse(
      response.data,
      statusCode: response.statusCode,
    );
  }

  Future<JsonMap> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.post<Object?>(
      path,
      data: body,
      queryParameters: query,
    );
    return ApiEnvelopeParser.parse(
      response.data,
      statusCode: response.statusCode,
    );
  }
}
