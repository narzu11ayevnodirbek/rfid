import 'package:flutter/services.dart';

class RfidService {
  static const MethodChannel _method = MethodChannel('rfid_channel');
  static const EventChannel _events = EventChannel('rfid_event_channel');

  Future<void> init() async => _method.invokeMethod('initTask');

  /// Запуск сканирования: после нажатия кнопки «Запустить RFID» на экране
  /// ридер начинает сразу считывать метки (без обязательного нажатия
  /// физического курка).
  Future<void> startScan() async => _method.invokeMethod('start');

  Future<void> stopScan() async => _method.invokeMethod('stop');

  Stream<String> get onTagRead =>
      _events.receiveBroadcastStream().cast<String>();

  Future<void> setPower(int level) async =>
      _method.invokeMethod('setPower', {'level': level});

  /// Запись EPC в MemoryBank.EPC метки (асинхронно).
  /// Нативная сторона (Android/iOS) должна реализовать метод 'writeEpc'.
  /// Возвращает успех или бросает PlatformException с кодом: WRITE_FAILED, WRITE_LOCK, NO_TAG_FOUND, MULTIPLE_TAGS.
  Future<void> writeEpc(String epc) async =>
      _method.invokeMethod('writeEpc', {'epc': epc});
}
