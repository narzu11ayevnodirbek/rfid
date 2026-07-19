import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:rfid/infrastructure/di/injector_container.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this.dio);

  final Dio dio;
  bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = localSource.getUserToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing && !_isRefreshRequest(err.requestOptions)) {
      _isRefreshing = true;

      try {
        final String newToken = await _refreshTokenRequest();
        await localSource.setUserToken(newToken);

        final RequestOptions requestOptions = err.requestOptions;

        final newHeaders = Map<String, dynamic>.from(requestOptions.headers);
        newHeaders['Authorization'] = 'Bearer $newToken';
        requestOptions.headers = newHeaders;
        print('newToken');

        final cloneResponse = await dio.fetch(requestOptions);
        Logger().e(requestOptions);
        return handler.resolve(cloneResponse);
      } catch (e) {
        return handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }

  Future<String> _refreshTokenRequest() async {
    final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl))
      ..interceptors.addAll([
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        )
      ]);
    (refreshDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient()..badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    final response = await refreshDio.post<dynamic>(
      '/api/auth.php',
      queryParameters: {'action': 'login'},
      data: {
        'login': 'superadmin',
        'password': 'abbos010101',
      },
    );

    return response.data['token'];
  }

  bool _isRefreshRequest(RequestOptions options) => options.path.contains('/api/auth.php');
}
