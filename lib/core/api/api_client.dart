import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:rf_id_test/injector_container.dart';

import 'interceptors/auth_interceptor.dart';

class ApiClient {
  static const String _baseUrl = 'http://localhost/';
  static const String _testBaseUrl = 'https://mderp.uz/';

  Dio _getDio() {
    final BaseOptions options = BaseOptions(
      baseUrl: _testBaseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
    );
    final dio = Dio(options);
    dio.interceptors.addAll([
      AuthInterceptor(dio),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    ]);
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient()..badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    return dio;
  }

  Dio get getDio => _getDio();
}

extension ApiExt on Response {
  bool get isSuccessful => statusCode == 200 || statusCode == 201;
}

Options optionsWithBearer() => Options(
      sendTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      headers: {
        'Authorization': 'Bearer ${localSource.getUserToken}',
      },
    );
