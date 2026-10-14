import 'dart:convert';
import 'dart:isolate';

abstract final class JsonBodyDecoder {
  static const int backgroundThreshold = 50 * 1024;

  // Dio moves decoding to an isolate only when Content-Length is known, and
  // the PHP backend sends chunked responses, so large bodies are decoded here.
  static Future<Object?> decode(String body) async {
    if (body.length < backgroundThreshold) return jsonDecode(body);
    return Isolate.run(() => jsonDecode(body));
  }
}
