import 'package:dio/dio.dart';

class HttpToHttpsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // If the request is using http, change it to https
    if (options.path.startsWith('http://')) {
      options.path = options.path.replaceFirst('http://', 'https://');
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions options = err.requestOptions;

    // Check if it's a network error or HTTP-specific error that needs retry with https
    if (_shouldRetryWithHttps(err, options)) {
      try {
        // Modify the base URL to use https
        options.baseUrl = options.baseUrl.replaceFirst('http://', 'https://');

        // Retry the request with the updated base URL
        final response = await Dio().fetch<dynamic>(options);
        return handler
            .resolve(response); // Resolve the request with new response
      } catch (e) {
        // If the retry also fails, return the original error
        return handler.next(err);
      }
    }

    // If it's not a retry case, continue with the error
    return handler.next(err);
  }

  // A helper method to decide if the request should be retried with https
  bool _shouldRetryWithHttps(
      DioException err,
      RequestOptions options,
      ) =>
      options.baseUrl.startsWith('http://') &&
          (err.type == DioExceptionType.connectionError ||
              err.type == DioExceptionType.badResponse);
}