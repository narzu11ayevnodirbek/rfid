import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_state.dart';

/// One screen's use of the reader: start, stop and the distinct tags read.
///
/// Each scan bloc owns a session (composition, not inheritance), forwards
/// [states] into its own state and calls [dispose] in `close()`, which stops
/// the reader whenever the screen goes away.
///
/// ```dart
/// _scanSubscription = _scan.states.listen((s) => add(ScanStateChanged(s)));
/// ...
/// @override
/// Future<void> close() async {
///   await _scanSubscription.cancel();
///   await _scan.dispose();
///   return super.close();
/// }
/// ```
class TagScanSession {
  TagScanSession({
    required RfidReader reader,
    required this.powerProfile,
    void Function()? onNewTag,
  })  : _reader = reader,
        _onNewTag = onNewTag ?? HapticFeedback.mediumImpact;

  final RfidReader _reader;
  final RfidPowerProfile powerProfile;
  final void Function() _onNewTag;

  final StreamController<TagScanState> _states =
      StreamController<TagScanState>.broadcast();
  final Set<String> _seen = {};

  StreamSubscription<RfidReaderEvent>? _readerSubscription;
  TagScanState _state = const TagScanState();
  bool _isDisposed = false;

  TagScanState get state => _state;

  Stream<TagScanState> get states => _states.stream;

  /// Powers the reader, applies [powerProfile] and starts scanning.
  /// A failure is reported in [TagScanState.failure], never thrown.
  Future<void> start() async {
    if (_isDisposed || _state.isScanning || _state.isBusy) return;
    _emit(_state.copyWith(isBusy: true, clearFailure: true));
    try {
      await _reader.initialize();
      await _reader.setPower(powerProfile.dbm);
      // Listen before starting so the first tags are not missed.
      _readerSubscription ??= _reader.events.listen(_onReaderEvent);
      await _reader.startScanning(
        readImmediately: RfidScanSettings.readImmediatelyOnStart,
      );
      _emit(_state.copyWith(isScanning: true, isBusy: false));
    } on RfidException catch (error) {
      _emit(
        _state.copyWith(
          isBusy: false,
          failure: RfidFailure(error.reason, details: error.details),
        ),
      );
    }
  }

  Future<void> stop() async {
    if (_isDisposed || !_state.isScanning) return;
    _emit(_state.copyWith(isBusy: true));
    try {
      await _reader.stopScanning();
    } on RfidException {
      // The reader is being switched off anyway; nothing to recover.
    }
    _emit(_state.copyWith(isScanning: false, isReading: false, isBusy: false));
  }

  Future<void> toggle() => _state.isScanning ? stop() : start();

  /// Forgets one tag, so it can be read again.
  void remove(String epc) {
    if (!_seen.remove(epc)) return;
    _emit(_state.copyWith(tags: List.unmodifiable(_seen)));
  }

  /// Forgets all tags.
  void clear() {
    _seen.clear();
    _emit(_state.copyWith(tags: const [], clearLastTag: true));
  }

  /// Puts back tags from a saved draft.
  void restore(Iterable<String> epcs) {
    _seen.addAll(epcs);
    _emit(_state.copyWith(tags: List.unmodifiable(_seen)));
  }

  /// Stops the reader and releases the session. Safe to call twice.
  Future<void> dispose() async {
    if (_isDisposed) return;
    await stop();
    _isDisposed = true;
    await _readerSubscription?.cancel();
    await _states.close();
  }

  void _onReaderEvent(RfidReaderEvent event) {
    switch (event) {
      case TagRead(:final epc):
        // Tags only count while the operator has the session switched on.
        if (!_state.isScanning) return;
        final isNew = _seen.add(epc);
        if (isNew) _onNewTag();
        _emit(
          _state.copyWith(
            tags: isNew ? List.unmodifiable(_seen) : null,
            lastTag: epc,
          ),
        );
      case ReadingStateChanged(:final isReading):
        _emit(_state.copyWith(isReading: isReading));
      case HardwareKeyPressed():
        break;
    }
  }

  void _emit(TagScanState next) {
    if (_isDisposed || next == _state) return;
    _state = next;
    _states.add(next);
  }
}
