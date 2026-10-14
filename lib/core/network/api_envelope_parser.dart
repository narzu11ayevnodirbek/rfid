import 'dart:convert';

import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/network/json_reader.dart';

abstract final class ApiEnvelopeParser {
  static JsonMap parse(Object? body, {int? statusCode}) {
    final json = asJsonMap(_decode(body));
    if (!JsonReader(json).boolean('success')) {
      throw ApiException(message: messageOf(json), statusCode: statusCode);
    }
    return json;
  }

  static String? messageOf(Object? body) {
    final Object? decoded;
    try {
      decoded = _decode(body);
    } on FormatException {
      return null;
    }
    if (decoded is! Map) return null;
    final reader = JsonReader(asJsonMap(decoded));
    final message =
        reader.firstString(const ['message', 'error', 'recommendation']);
    return message.isEmpty ? null : message;
  }

  static Object? _decode(Object? body) {
    if (body is String) return jsonDecode(body);
    return body;
  }
}
