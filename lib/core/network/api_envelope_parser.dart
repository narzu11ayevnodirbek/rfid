import 'dart:convert';

import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/network/json_reader.dart';

/// Understands the envelope every endpoint answers with:
///
/// ```json
/// { "success": true, "data": [...] }
/// { "success": false, "message": "..." }   // or "error"
/// ```
abstract final class ApiEnvelopeParser {
  /// Returns the response body after checking that the request succeeded.
  ///
  /// Throws [ApiException] with the server's message when `success` is not
  /// true, and [FormatException] when the body is not a JSON object.
  static JsonMap parse(Object? body, {int? statusCode}) {
    final json = asJsonMap(_decode(body));
    if (!JsonReader(json).boolean('success')) {
      throw ApiException(message: messageOf(json), statusCode: statusCode);
    }
    return json;
  }

  /// The human-readable message of a response, whatever key it is under.
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

  /// Some PHP endpoints send JSON with a `text/html` content type, in which
  /// case the HTTP client hands the body over as a plain string.
  static Object? _decode(Object? body) {
    if (body is String) return jsonDecode(body);
    return body;
  }
}
