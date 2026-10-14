import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug log: pretty JSON, password and token hidden, large bodies cut.
class ApiLogInterceptor extends Interceptor {
  ApiLogInterceptor({void Function(String line)? log})
      : _log = log ?? debugPrint;

  static const int fullBodyLimit = 20 * 1024;
  static const int previewLength = 2000;
  static const Set<String> _secretKeys = {'password', 'token'};
  static const String _startedAtKey = 'api_log_started_at';
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  final void Function(String line) _log;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now();
    _log('→ ${options.method} ${options.uri}');
    if (options.data != null) _log(_describe(options.data));
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(
      '← ${response.statusCode} '
      '${_summary(response.requestOptions, response.data)}',
    );
    _log(_describe(response.data));
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    _log(
      '✕ ${response?.statusCode ?? err.type.name} '
      '${_summary(err.requestOptions, response?.data)}',
    );
    if (response?.data != null) _log(_describe(response!.data));
    handler.next(err);
  }

  String _summary(RequestOptions options, Object? body) {
    final startedAt = options.extra[_startedAtKey];
    final elapsed = startedAt is DateTime
        ? '${DateTime.now().difference(startedAt).inMilliseconds} ms'
        : '? ms';
    final size = body is String ? ', ${_formatSize(body.length)}' : '';
    return '${options.method} ${options.uri} ($elapsed$size)';
  }

  String _describe(Object? body) {
    if (body is! String) return _encoder.convert(_hideSecrets(body));
    if (body.length > fullBodyLimit) {
      return '${body.substring(0, previewLength)}… '
          '(${_formatSize(body.length)}, cut)';
    }
    try {
      return _encoder.convert(_hideSecrets(jsonDecode(body)));
    } on FormatException {
      return body;
    }
  }

  Object? _hideSecrets(Object? value) => switch (value) {
        Map() => {
            for (final MapEntry(:key, value: item) in value.entries)
              '$key': _secretKeys.contains(key) ? '***' : _hideSecrets(item),
          },
        List() => [for (final item in value) _hideSecrets(item)],
        _ => value,
      };

  static String _formatSize(int length) {
    if (length < 1024) return '$length B';
    if (length < 1024 * 1024) return '${(length / 1024).toStringAsFixed(1)} KB';
    return '${(length / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
