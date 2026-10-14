import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_log_interceptor.dart';
import 'package:rfid/core/network/json_body_decoder.dart';
import 'package:rfid/core/network/json_reader.dart';

class _JsonAdapter implements HttpClientAdapter {
  _JsonAdapter(this.body);

  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(String body, {List<Interceptor> interceptors = const []}) => Dio(
      BaseOptions(
        baseUrl: 'https://example.test/',
        responseType: ResponseType.plain,
      ),
    )
      ..httpClientAdapter = _JsonAdapter(body)
      ..interceptors.addAll(interceptors);

int _countRows(JsonMap body) => JsonReader(body).mapList('data').length;

String _largeBody(int rows) => jsonEncode({
      'success': true,
      'data': [
        for (var i = 0; i < rows; i++)
          {'id': '$i', 'name': 'Item number $i with a fairly long name'},
      ],
    });

void main() {
  group('JsonBodyDecoder', () {
    test('decodes small and large bodies the same way', () async {
      final large = _largeBody(5000);
      expect(large.length, greaterThan(JsonBodyDecoder.backgroundThreshold));

      expect(await JsonBodyDecoder.decode('{"a":1}'), {'a': 1});
      final decoded = await JsonBodyDecoder.decode(large) as Map;
      expect((decoded['data'] as List).length, 5000);
    });

    test('rejects invalid JSON', () async {
      await expectLater(
        JsonBodyDecoder.decode('<html>'),
        throwsFormatException,
      );
    });
  });

  group('ApiClient', () {
    test('returns the checked body of a plain-text response', () async {
      final api = ApiClient(_dio('{"success":true,"data":[{"id":1}]}'));

      final body = await api.get('api/items.php');

      expect(body['data'], [
        {'id': 1},
      ]);
    });

    test('getInBackground decodes and converts off the UI isolate', () async {
      final api = ApiClient(_dio(_largeBody(3000)));

      final rows = await api.getInBackground('api/items.php', _countRows);

      expect(rows, 3000);
    });

    test('getInBackground passes the server refusal back', () async {
      final api = ApiClient(_dio('{"success":false,"message":"Нет доступа"}'));

      await expectLater(
        api.getInBackground('api/items.php', _countRows),
        throwsA(
          isA<ApiException>()
              .having((e) => e.message, 'message', 'Нет доступа'),
        ),
      );
    });
  });

  group('ApiLogInterceptor', () {
    test('hides secrets and cuts large bodies', () async {
      final lines = <String>[];
      final logger = ApiLogInterceptor(log: lines.add);

      await ApiClient(
        _dio('{"success":true,"token":"secret-token"}', interceptors: [logger]),
      ).post('api/auth.php', body: {'login': 'op', 'password': 'p4ss'});
      await ApiClient(_dio(_largeBody(3000), interceptors: [logger]))
          .get('api/items.php');

      final log = lines.join('\n');
      expect(log, isNot(contains('p4ss')));
      expect(log, isNot(contains('secret-token')));
      expect(log, contains('"login": "op"'));
      expect(log, contains('cut)'));
      expect(
        lines.every((line) => line.length < ApiLogInterceptor.fullBodyLimit),
        isTrue,
      );
    });
  });
}
