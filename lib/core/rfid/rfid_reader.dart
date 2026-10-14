/// Something the reader reports while it is in use.
sealed class RfidReaderEvent {
  const RfidReaderEvent();
}

/// A tag was read. [epc] is already normalized (see `Epc.normalize`).
///
/// The native side reports each tag once per reading burst, so the same EPC
/// can arrive again after the reader was stopped and started.
final class TagRead extends RfidReaderEvent {
  const TagRead(this.epc);

  final String epc;
}

/// The radio started or stopped reading (button, trigger or app pause).
final class ReadingStateChanged extends RfidReaderEvent {
  const ReadingStateChanged({required this.isReading});

  final bool isReading;
}

/// A hardware key was pressed or released. Only reported while key event
/// reporting is on (diagnostics), to find the trigger's key code.
final class HardwareKeyPressed extends RfidReaderEvent {
  const HardwareKeyPressed({required this.keyCode, required this.isDown});

  final int keyCode;
  final bool isDown;
}

/// The UHF reader built into the handheld.
///
/// Methods throw `RfidException` when the hardware cannot do what was asked.
/// Screens do not use this directly: they go through `TagScanSession`, which
/// handles the start/stop sequence and collects the tags.
abstract interface class RfidReader {
  /// Everything the reader reports. A broadcast stream that lives as long as
  /// the app.
  Stream<RfidReaderEvent> get events;

  /// Powers the module on. Safe to call repeatedly.
  Future<void> initialize();

  /// Sets the radio power in dBm (clamped to the supported range).
  /// Returns whether the module accepted it.
  Future<bool> setPower(int dbm);

  /// Arms the hardware trigger and, if [readImmediately], starts reading.
  Future<void> startScanning({required bool readImmediately});

  /// Stops reading and disarms the trigger.
  Future<void> stopScanning();

  /// Turns [HardwareKeyPressed] events on or off.
  Future<void> setKeyEventReporting({required bool enabled});
}
