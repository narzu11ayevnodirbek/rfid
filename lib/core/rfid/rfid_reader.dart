sealed class RfidReaderEvent {
  const RfidReaderEvent();
}

final class TagRead extends RfidReaderEvent {
  const TagRead(this.epc);

  final String epc;
}

final class ReadingStateChanged extends RfidReaderEvent {
  const ReadingStateChanged({required this.isReading});

  final bool isReading;
}

final class HardwareKeyPressed extends RfidReaderEvent {
  const HardwareKeyPressed({required this.keyCode, required this.isDown});

  final int keyCode;
  final bool isDown;
}

abstract interface class RfidReader {
  Stream<RfidReaderEvent> get events;

  Future<void> initialize();

  Future<bool> setPower(int dbm);

  Future<void> startScanning({required bool readImmediately});

  Future<void> stopScanning();

  Future<void> setKeyEventReporting({required bool enabled});
}
