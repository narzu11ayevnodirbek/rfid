import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/rfid/epc.dart';

void main() {
  test('trims and upper-cases EPCs', () {
    expect(Epc.normalize(' e2806894000050 '), 'E2806894000050');
    expect(Epc.normalize('E2806894000050'), 'E2806894000050');
    expect(Epc.normalize('   '), '');
  });
}
