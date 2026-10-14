import 'package:dio/dio.dart';

class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({
    required this.readToken,
    required this.onUnauthorized,
  });

  static const String _tokenExtraKey = 'auth_token';

  final String? Function() readToken;

  final void Function(String rejectedToken) onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      // Lets onError tell which session a late 401 belongs to.
      options.extra[_tokenExtraKey] = token;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final sentToken = err.requestOptions.extra[_tokenExtraKey];
    if (err.response?.statusCode == 401 && sentToken is String) {
      onUnauthorized(sentToken);
    }
    handler.next(err);
  }
}
