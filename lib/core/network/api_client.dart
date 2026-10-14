import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rfid/core/config/app_config.dart';
import 'package:rfid/core/network/api_envelope_parser.dart';
import 'package:rfid/core/network/api_log_interceptor.dart';
import 'package:rfid/core/network/auth_token_interceptor.dart';
import 'package:rfid/core/network/json_body_decoder.dart';
import 'package:rfid/core/network/json_reader.dart';

/// Returns bodies already checked for `success: true`; failures are thrown
/// and turned into `Failure`s by `guard()` in the repositories.
class ApiClient {
  ApiClient(this._dio);

  factory ApiClient.create({
    required String? Function() readToken,
    required void Function(String rejectedToken) onUnauthorized,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
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
    if (kDebugMode) dio.interceptors.add(ApiLogInterceptor());
    return ApiClient(dio);
  }

  final Dio _dio;

  Future<JsonMap> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<String>(path, queryParameters: query);
    return _parse(response);
  }

  Future<JsonMap> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.post<String>(
      path,
      data: body,
      queryParameters: query,
    );
    return _parse(response);
  }

  /// Decodes and converts the body in one background isolate. [convert] must
  /// be a top-level or static function.
  Future<T> getInBackground<T>(
    String path,
    T Function(JsonMap body) convert, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.get<String>(path, queryParameters: query);
    final body = response.data ?? '';
    final statusCode = response.statusCode;
    return Isolate.run(
      () => convert(
        ApiEnvelopeParser.parse(jsonDecode(body), statusCode: statusCode),
      ),
    );
  }

  Future<JsonMap> _parse(Response<String> response) async {
    final decoded = await JsonBodyDecoder.decode(response.data ?? '');
    return ApiEnvelopeParser.parse(decoded, statusCode: response.statusCode);
  }
}
