import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/repository_guard.dart';
import 'package:rfid/core/error/result.dart';

DioException _httpError(int statusCode, Object? body) {
  final request = RequestOptions(path: 'api/test.php');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: request,
      statusCode: statusCode,
      data: body,
    ),
  );
}

void main() {
  group('guard', () {
    test('wraps the value on success', () async {
      final result = await guard(() async => 42);

      expect(result, isA<Success<int>>());
      expect(result.valueOrNull, 42);
    });

    test('maps a refused request to ServerFailure with the server text',
        () async {
      final result = await guard<int>(
        () async =>
            throw const ApiException(message: 'Занято', statusCode: 200),
      );

      expect(
        result.failureOrNull,
        const ServerFailure(message: 'Занято', statusCode: 200),
      );
    });

    test('maps HTTP 401 to UnauthorizedFailure', () async {
      final result = await guard<int>(
        () async => throw _httpError(401, {'error': 'Token expired'}),
      );

      expect(
        result.failureOrNull,
        const UnauthorizedFailure(message: 'Token expired'),
      );
    });

    test('maps other HTTP errors to ServerFailure', () async {
      final result = await guard<int>(
        () async => throw _httpError(500, '<html>oops</html>'),
      );

      expect(result.failureOrNull, const ServerFailure(statusCode: 500));
    });

    test('maps a request without a response to NetworkFailure', () async {
      final result = await guard<int>(
        () async => throw DioException(
          requestOptions: RequestOptions(path: 'api/test.php'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(result.failureOrNull, const NetworkFailure());
    });

    test('maps unreadable data to ParsingFailure', () async {
      final badFormat = await guard<int>(
        () async => throw const FormatException('not json'),
      );
      final badType = await guard<int>(() async => ('text' as dynamic) as int);

      expect(badFormat.failureOrNull, const ParsingFailure('not json'));
      expect(badType.failureOrNull, isA<ParsingFailure>());
    });

    test('maps reader errors to RfidFailure', () async {
      final result = await guard<int>(
        () async => throw const RfidException(RfidFailureReason.unavailable),
      );

      expect(
        result.failureOrNull,
        const RfidFailure(RfidFailureReason.unavailable),
      );
    });

    test('maps anything else to UnexpectedFailure', () async {
      final result = await guard<int>(() async => throw StateError('boom'));

      expect(result.failureOrNull, isA<UnexpectedFailure>());
    });
  });
}
