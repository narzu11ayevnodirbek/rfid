import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/rfid/epc.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';

/// [RfidReader] backed by the Chainway SDK through platform channels.
///
/// The Kotlin side lives in `android/app/src/main/kotlin/.../rfid/`; the
/// channel contract is documented in `docs/RFID.md`.
///
/// The event channel is listened to exactly once, here, and re-broadcast on
/// [events]. Opening it from several places (as the legacy app did) lets one
/// listener silence the others, because the native side keeps a single sink.
class PlatformRfidReader implements RfidReader {
  PlatformRfidReader({
    MethodChannel methodChannel = const MethodChannel(_methodChannelName),
    EventChannel eventChannel = const EventChannel(_eventChannelName),
  })  : _methods = methodChannel,
        _platformEvents = eventChannel;

  static const String _methodChannelName = 'uz.tatu.rfid/reader';
  static const String _eventChannelName = 'uz.tatu.rfid/reader_events';

  final MethodChannel _methods;
  final EventChannel _platformEvents;
  final StreamController<RfidReaderEvent> _events =
      StreamController<RfidReaderEvent>.broadcast();

  StreamSubscription<Object?>? _platformSubscription;
  bool _isInitialized = false;

  @override
  Stream<RfidReaderEvent> get events {
    _listenToPlatformOnce();
    return _events.stream;
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    _listenToPlatformOnce();
    final ok = await _invoke<bool>('initialize');
    if (ok != true) throw const RfidException(RfidFailureReason.initFailed);
    _isInitialized = true;
  }

  @override
  Future<bool> setPower(int dbm) async {
    final level = dbm.clamp(
      RfidScanSettings.minPowerDbm,
      RfidScanSettings.maxPowerDbm,
    );
    return await _invoke<bool>('setPower', {'dbm': level}) ?? false;
  }

  @override
  Future<void> startScanning({required bool readImmediately}) async {
    final ok = await _invoke<bool>(
      'startScanning',
      {'readImmediately': readImmediately},
    );
    if (ok != true) {
      throw const RfidException(
        RfidFailureReason.commandFailed,
        details: 'startScanning returned false',
      );
    }
  }

  @override
  Future<void> stopScanning() => _invoke<bool>('stopScanning');

  @override
  Future<void> setKeyEventReporting({required bool enabled}) =>
      _invoke<bool>('setKeyEventReporting', {'enabled': enabled});

  @override
  Future<void> release() async {
    await _invoke<bool>('release');
    _isInitialized = false;
  }

  void _listenToPlatformOnce() {
    _platformSubscription ??= _platformEvents.receiveBroadcastStream().listen(
          _onPlatformEvent,
          // A broken event must not kill the only subscription.
          onError: (Object _) {},
        );
  }

  void _onPlatformEvent(Object? raw) {
    if (raw is! Map) return;
    final event = switch (raw['type']) {
      'tag' => _tagEvent(raw['epc']),
      'reading' => ReadingStateChanged(isReading: raw['value'] == true),
      'key' => HardwareKeyPressed(
          keyCode: raw['code'] is int ? raw['code'] as int : -1,
          isDown: raw['down'] == true,
        ),
      _ => null,
    };
    if (event != null) _events.add(event);
  }

  TagRead? _tagEvent(Object? rawEpc) {
    if (rawEpc is! String) return null;
    final epc = Epc.normalize(rawEpc);
    return epc.isEmpty ? null : TagRead(epc);
  }

  Future<T?> _invoke<T>(
    String method, [
    Map<String, Object?>? arguments,
  ]) async {
    try {
      return await _methods.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      // Not running on the handheld (or the native side is missing).
      throw const RfidException(RfidFailureReason.unavailable);
    } on PlatformException catch (error) {
      throw RfidException(
        switch (error.code) {
          'UNAVAILABLE' => RfidFailureReason.unavailable,
          'INIT_FAILED' => RfidFailureReason.initFailed,
          _ => RfidFailureReason.commandFailed,
        },
        details: error.message,
      );
    }
  }
}
