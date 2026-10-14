import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/network/api_envelope_parser.dart';

void main() {
  group('ApiEnvelopeParser.parse', () {
    test('returns the body of a successful response', () {
      final json = ApiEnvelopeParser.parse({
        'success': true,
        'data': [1, 2],
      });

      expect(json['data'], [1, 2]);
    });

    test('decodes a body delivered as a string', () {
      final json = ApiEnvelopeParser.parse('{"success":true,"token":"t"}');

      expect(json['token'], 't');
    });

    test('throws the server message when success is false', () {
      expect(
        () => ApiEnvelopeParser.parse(
          {'success': false, 'message': 'Нет доступа'},
          statusCode: 200,
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.message, 'message', 'Нет доступа')
              .having((e) => e.statusCode, 'statusCode', 200),
        ),
      );
    });

    test('throws when success is missing', () {
      expect(
        () => ApiEnvelopeParser.parse({'data': []}),
        throwsA(isA<ApiException>()),
      );
    });

    test('rejects bodies that are not JSON objects', () {
      expect(() => ApiEnvelopeParser.parse('<html>'), throwsFormatException);
      expect(() => ApiEnvelopeParser.parse([1]), throwsFormatException);
      expect(() => ApiEnvelopeParser.parse(null), throwsFormatException);
    });
  });

  group('ApiEnvelopeParser.messageOf', () {
    test('prefers message, then error, then recommendation', () {
      expect(
        ApiEnvelopeParser.messageOf({'message': 'm', 'error': 'e'}),
        'm',
      );
      expect(ApiEnvelopeParser.messageOf({'error': 'e'}), 'e');
      expect(ApiEnvelopeParser.messageOf({'recommendation': 'r'}), 'r');
    });

    test('returns null when there is nothing readable', () {
      expect(ApiEnvelopeParser.messageOf({'success': false}), isNull);
      expect(ApiEnvelopeParser.messageOf('<html>'), isNull);
      expect(ApiEnvelopeParser.messageOf(null), isNull);
    });
  });
}
