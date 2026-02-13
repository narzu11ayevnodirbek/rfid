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


  Future<bool> sendTagRequest({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final dio = sl<Dio>();

      final response = await dio.post(
        endpoint,
        data: body,
        options: optionsWithBearer(),
      );

      print('📤 POST → $endpoint');
      print('📦 Body → $body');
      print('📥 Response → ${response.data}');

      return response.data['success'] == true;
    } catch (e) {
      print('❌ sendTagRequest error: $e');
      return false;
    }
  }

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
