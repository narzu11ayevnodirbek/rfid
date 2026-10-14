import 'dart:async';

import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/rfid/epc.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';

/// [RfidReader] without hardware, for tests and for running the app on an
/// emulator or desktop (`--dart-define=FAKE_RFID=true`).
///
/// While scanning it reads [demoTags] one by one when [demoInterval] is set;
/// tests call [simulateTag] instead.
class FakeRfidReader implements RfidReader {
  FakeRfidReader({
    this.demoTags = const [
      'E28068940000501EC0B8A1A1',
      'E28068940000401EC0B8A1A2',
      'E28068940000501EC0B8A1A3',
      'E28068940000401EC0B8A1A4',
      'E28068940000501EC0B8A1A5',
    ],
    this.demoInterval,
    this.initializeFailure,
  });

  final List<String> demoTags;
  final Duration? demoInterval;

  /// When set, [initialize] throws an `RfidException` with this reason.
  final RfidFailureReason? initializeFailure;

  final StreamController<RfidReaderEvent> _events =
      StreamController<RfidReaderEvent>.broadcast();

  Timer? _demoTimer;
  int _nextDemoTag = 0;

  bool isInitialized = false;
  bool isScanning = false;
  bool isReading = false;
  bool reportsKeyEvents = false;
  int? powerDbm;

  @override
  Stream<RfidReaderEvent> get events => _events.stream;

  @override
  Future<void> initialize() async {
    if (initializeFailure case final reason?) throw RfidException(reason);
    isInitialized = true;
  }

  @override
  Future<bool> setPower(int dbm) async {
    powerDbm = dbm;
    return true;
  }

  @override
  Future<void> startScanning({required bool readImmediately}) async {
    isScanning = true;
    if (readImmediately) _setReading(true);
    final interval = demoInterval;
    if (interval != null && demoTags.isNotEmpty) {
      _demoTimer?.cancel();
      _demoTimer = Timer.periodic(interval, (_) {
        simulateTag(demoTags[_nextDemoTag++ % demoTags.length]);
      });
    }
  }

  @override
  Future<void> stopScanning() async {
    _demoTimer?.cancel();
    isScanning = false;
    _setReading(false);
  }

  @override
  Future<void> setKeyEventReporting({required bool enabled}) async {
    reportsKeyEvents = enabled;
  }

  /// Pretends the radio read [epc]. Ignored unless scanning, like hardware.
  void simulateTag(String epc) {
    if (!isScanning) return;
    _events.add(TagRead(Epc.normalize(epc)));
  }

  /// Pretends the operator pressed or released a hardware key.
  void simulateKey(int keyCode, {required bool isDown}) {
    if (!reportsKeyEvents) return;
    _events.add(HardwareKeyPressed(keyCode: keyCode, isDown: isDown));
  }

  void _setReading(bool value) {
    if (isReading == value) return;
    isReading = value;
    _events.add(ReadingStateChanged(isReading: value));
  }
}
