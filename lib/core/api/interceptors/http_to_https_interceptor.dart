import 'package:dio/dio.dart';

class HttpToHttpsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.startsWith('http://')) {
      options.path = options.path.replaceFirst('http://', 'https://');
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions options = err.requestOptions;

    if (_shouldRetryWithHttps(err, options)) {
      try {
        options.baseUrl = options.baseUrl.replaceFirst('http://', 'https://');

        final response = await Dio().fetch<dynamic>(options);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetryWithHttps(
    DioException err,
    RequestOptions options,
  ) =>
      options.baseUrl.startsWith('http://') &&
      (err.type == DioExceptionType.connectionError || err.type == DioExceptionType.badResponse);
}
