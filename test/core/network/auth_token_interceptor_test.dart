import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/network/auth_token_interceptor.dart';

class _FixedStatusAdapter implements HttpClientAdapter {
  _FixedStatusAdapter(this.statusCode);

  final int statusCode;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{"success":${statusCode == 200}}',
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late List<String> rejectedTokens;
  String? currentToken;

  Dio buildDio(_FixedStatusAdapter adapter) {
    return Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthTokenInterceptor(
          readToken: () => currentToken,
          onUnauthorized: rejectedTokens.add,
        ),
      );
  }

  setUp(() {
    rejectedTokens = [];
    currentToken = null;
  });

  test('adds the bearer token when there is a session', () async {
    final adapter = _FixedStatusAdapter(200);
    currentToken = 'abc';

    await buildDio(adapter).get<Object?>('api/inventory.php');

    expect(adapter.lastRequest!.headers['Authorization'], 'Bearer abc');
  });

  test('sends no Authorization header without a session', () async {
    final adapter = _FixedStatusAdapter(200);

    await buildDio(adapter).get<Object?>('api/auth.php');

    expect(adapter.lastRequest!.headers.containsKey('Authorization'), isFalse);
  });

  test('reports the token the server rejected with 401', () async {
    currentToken = 'expired';

    await expectLater(
      buildDio(_FixedStatusAdapter(401)).get<Object?>('api/inventory.php'),
      throwsA(isA<DioException>()),
    );

    expect(rejectedTokens, ['expired']);
  });

  test('does not report a 401 for a request sent without a token', () async {
    await expectLater(
      buildDio(_FixedStatusAdapter(401)).post<Object?>('api/auth.php'),
      throwsA(isA<DioException>()),
    );

    expect(rejectedTokens, isEmpty);
  });

  test('ignores errors other than 401', () async {
    currentToken = 'abc';

    await expectLater(
      buildDio(_FixedStatusAdapter(500)).get<Object?>('api/inventory.php'),
      throwsA(isA<DioException>()),
    );

    expect(rejectedTokens, isEmpty);
  });
}
