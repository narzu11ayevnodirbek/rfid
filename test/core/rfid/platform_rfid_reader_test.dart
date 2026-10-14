import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/rfid/platform_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const methods = MethodChannel('test/reader');
  const events = EventChannel('test/reader_events');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<MethodCall> calls;
  late Object? Function(MethodCall call) answer;

  setUp(() {
    calls = [];
    answer = (_) => true;
    messenger.setMockMethodCallHandler(methods, (call) async {
      calls.add(call);
      return answer(call);
    });
  });

  tearDown(() {
    messenger
      ..setMockMethodCallHandler(methods, null)
      ..setMockStreamHandler(events, null);
  });

  PlatformRfidReader buildReader() =>
      PlatformRfidReader(methodChannel: methods, eventChannel: events);

  test('initializes once', () async {
    final reader = buildReader();

    await reader.initialize();
    await reader.initialize();

    expect(calls.where((c) => c.method == 'initialize'), hasLength(1));
  });

  test('turns platform errors into RfidException reasons', () async {
    answer = (_) => throw PlatformException(code: 'UNAVAILABLE');

    await expectLater(
      buildReader().initialize(),
      throwsA(
        isA<RfidException>()
            .having((e) => e.reason, 'reason', RfidFailureReason.unavailable),
      ),
    );
  });

  test('a false init result is an init failure', () async {
    answer = (_) => false;

    await expectLater(
      buildReader().initialize(),
      throwsA(
        isA<RfidException>()
            .having((e) => e.reason, 'reason', RfidFailureReason.initFailed),
      ),
    );
  });

  test('clamps power to the supported range', () async {
    final reader = buildReader();

    await reader.setPower(99);
    await reader.setPower(1);

    expect(calls.map((c) => c.arguments), [
      {'dbm': 30},
      {'dbm': 5},
    ]);
  });

  test('passes the start mode to the native side', () async {
    await buildReader().startScanning(readImmediately: true);

    expect(calls.single.method, 'startScanning');
    expect(calls.single.arguments, {'readImmediately': true});
  });

  test('parses platform events and normalizes EPCs', () async {
    messenger.setMockStreamHandler(
      events,
      MockStreamHandler.inline(
        onListen: (_, sink) {
          sink
            ..success({'type': 'tag', 'epc': ' e2001 '})
            ..success({'type': 'reading', 'value': true})
            ..success({'type': 'key', 'code': 293, 'down': true})
            ..success({'type': 'tag', 'epc': '  '})
            ..success('garbage');
        },
      ),
    );
    final reader = buildReader();
    final received = <RfidReaderEvent>[];
    reader.events.listen(received.add);
    await pumpEventQueue();

    expect(received, hasLength(3));
    expect((received[0] as TagRead).epc, 'E2001');
    expect((received[1] as ReadingStateChanged).isReading, isTrue);
    expect((received[2] as HardwareKeyPressed).keyCode, 293);
  });
}
