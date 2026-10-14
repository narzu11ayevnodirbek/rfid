import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/network/json_reader.dart';

void main() {
  group('JsonReader', () {
    test('reads integers sent as numbers, decimals or text', () {
      const reader = JsonReader({'a': 12, 'b': '12', 'c': 12.0, 'd': ' 7 '});

      expect(reader.integer('a'), 12);
      expect(reader.integer('b'), 12);
      expect(reader.integer('c'), 12);
      expect(reader.integer('d'), 7);
    });

    test('falls back when an integer is missing or not a number', () {
      const reader = JsonReader({'a': null, 'b': 'abc', 'c': ''});

      expect(reader.integer('a'), 0);
      expect(reader.integer('b', fallback: -1), -1);
      expect(reader.integerOrNull('c'), isNull);
      expect(reader.integerOrNull('missing'), isNull);
    });

    test('reads any scalar as text', () {
      const reader = JsonReader({'id': 5, 'name': 'Stol', 'none': null});

      expect(reader.string('id'), '5');
      expect(reader.string('name'), 'Stol');
      expect(reader.string('none'), '');
      expect(reader.string('missing', fallback: '-'), '-');
    });

    test('treats empty text as no value', () {
      const reader = JsonReader({'photo': '', 'photo_path': 'uploads/a.jpg'});

      expect(reader.stringOrNull('photo'), isNull);
      expect(reader.firstString(const ['photo', 'photo_path']), 'uploads/a.jpg');
      expect(reader.firstString(const ['x', 'y'], fallback: '?'), '?');
    });

    test('reads flags sent as bool, number or text', () {
      const reader = JsonReader({
        'a': true,
        'b': 1,
        'c': '1',
        'd': 'true',
        'e': 0,
        'f': '0',
        'g': null,
      });

      expect(reader.boolean('a'), isTrue);
      expect(reader.boolean('b'), isTrue);
      expect(reader.boolean('c'), isTrue);
      expect(reader.boolean('d'), isTrue);
      expect(reader.boolean('e'), isFalse);
      expect(reader.boolean('f'), isFalse);
      expect(reader.boolean('g'), isFalse);
    });

    test('reads lists and skips elements of the wrong kind', () {
      const reader = JsonReader({
        'rows': [
          {'id': 1},
          'junk',
          {'id': 2},
        ],
        'tags': ['A', null, 3],
        'not_a_list': 'x',
      });

      expect(reader.mapList('rows'), hasLength(2));
      expect(reader.stringList('tags'), ['A', '3']);
      expect(reader.mapList('not_a_list'), isEmpty);
      expect(reader.stringList('missing'), isEmpty);
    });

    test('reduces mixed object/scalar lists to labels', () {
      const reader = JsonReader({
        'blocked': [
          {'name': 'Printer', 'status': 'repair'},
          {'item_id': 9},
          'E200AA',
        ],
      });

      expect(
        reader.labelList('blocked', labelKeys: const ['name', 'item_id']),
        ['Printer', '9', 'E200AA'],
      );
    });
  });

  group('asJsonMap', () {
    test('accepts loosely typed maps', () {
      expect(asJsonMap(<dynamic, dynamic>{'a': 1}), {'a': 1});
    });

    test('rejects anything that is not an object', () {
      expect(() => asJsonMap([1, 2]), throwsFormatException);
      expect(() => asJsonMap(null), throwsFormatException);
    });
  });
}
