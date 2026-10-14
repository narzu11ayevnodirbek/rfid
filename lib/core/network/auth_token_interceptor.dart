import 'package:dio/dio.dart';

/// Adds the session token to every request and reports rejected tokens.
///
/// The interceptor knows nothing about storage or navigation: it gets two
/// functions. What happens after a rejected token (clearing the session,
/// showing the login screen) is decided by whoever provides [onUnauthorized].
class AuthTokenInterceptor extends Interceptor {
  AuthTokenInterceptor({
    required this.readToken,
    required this.onUnauthorized,
  });

  static const String _tokenExtraKey = 'auth_token';

  final String? Function() readToken;

  /// Called with the token that the server answered 401 to.
  final void Function(String rejectedToken) onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      // Remembered so that a slow 401 cannot end a session started later.
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
