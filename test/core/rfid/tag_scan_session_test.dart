import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/rfid/fake_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';

void main() {
  late FakeRfidReader reader;
  late TagScanSession session;
  late int newTagSignals;

  TagScanSession buildSession(FakeRfidReader reader) => TagScanSession(
        reader: reader,
        powerProfile: RfidPowerProfile.movement,
        onNewTag: () => newTagSignals++,
      );

  setUp(() {
    newTagSignals = 0;
    reader = FakeRfidReader();
    session = buildSession(reader);
  });

  tearDown(() => session.dispose());

  test('start powers the reader with the profile power and starts scanning',
      () async {
    await session.start();

    expect(reader.isInitialized, isTrue);
    expect(reader.powerDbm, RfidPowerProfile.movement.dbm);
    expect(reader.isScanning, isTrue);
    expect(session.state.isScanning, isTrue);
    expect(session.state.isBusy, isFalse);
  });

  test('collects each tag once, in reading order', () async {
    await session.start();

    reader
      ..simulateTag('e2001')
      ..simulateTag('E2002')
      ..simulateTag(' e2001 ');
    await pumpEventQueue();

    expect(session.state.tags, ['E2001', 'E2002']);
    expect(session.state.lastTag, 'E2001');
    expect(newTagSignals, 2);
  });

  test('ignores tags while stopped', () async {
    await session.start();
    await session.stop();

    reader.simulateTag('E2001');
    await pumpEventQueue();

    expect(session.state.tags, isEmpty);
    expect(reader.isScanning, isFalse);
  });

  test('remove lets a tag be read again; clear forgets all', () async {
    await session.start();
    reader
      ..simulateTag('E1')
      ..simulateTag('E2');
    await pumpEventQueue();

    session.remove('E1');
    expect(session.state.tags, ['E2']);

    reader.simulateTag('E1');
    await pumpEventQueue();
    expect(session.state.tags, ['E2', 'E1']);

    session.clear();
    expect(session.state.tags, isEmpty);
    expect(session.state.lastTag, isNull);
  });

  test('restore puts back drafted tags without duplicates', () async {
    session.restore(['E1', 'E2']);
    await session.start();
    reader.simulateTag('E2');
    await pumpEventQueue();

    expect(session.state.tags, ['E1', 'E2']);
  });

  test('reports a reader that cannot start instead of throwing', () async {
    final broken = buildSession(
      FakeRfidReader(initializeFailure: RfidFailureReason.unavailable),
    );

    await broken.start();

    expect(broken.state.isScanning, isFalse);
    expect(broken.state.isBusy, isFalse);
    expect(
      broken.state.failure,
      const RfidFailure(RfidFailureReason.unavailable),
    );
    await broken.dispose();
  });

  test('follows the reading indicator of the radio', () async {
    await session.start();
    await pumpEventQueue();
    expect(session.state.isReading, RfidScanSettings.readImmediatelyOnStart);

    await session.stop();
    expect(session.state.isReading, isFalse);
  });

  test('dispose stops the reader', () async {
    await session.start();

    await session.dispose();

    expect(reader.isScanning, isFalse);
  });
}
