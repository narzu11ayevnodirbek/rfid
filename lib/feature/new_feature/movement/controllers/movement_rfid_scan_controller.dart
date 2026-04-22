import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../rfid/rfid_service.dart';
import '../../utils/app_dialog.dart';
import '../../utils/app_snackbar.dart';
import '../models/movement_task_model.dart';
import '../services/transfer_service.dart';

/// Контроллер экрана перемещения: сканирование меток списком, удаление по X, отправка пакета на сервер.
class MovementRfidScanController extends GetxController {
  MovementRfidScanController(this.task);

  final MovementTaskModel task;
  final TransferService _service = TransferService();
  final RfidService _rfid = RfidService();

  final RxSet<String> _scannedSet = <String>{}.obs;
  List<String> get scannedList => _scannedSet.toList();
  int get scannedCount => _scannedSet.length;

  RxBool isScanning = false.obs;
  RxBool isSending = false.obs;
  StreamSubscription<String>? _rfidSub;

  static String _normEpc(String e) => e.trim().toUpperCase();

  @override
  void onClose() {
    _rfidSub?.cancel();
    _rfid.stopScan();
    super.onClose();
  }

  Future<void> startScan() async {
    if (isScanning.value) return;
    try {
      await _rfid.init();
      await _rfid.setPower(18);
      await _rfidSub?.cancel();
      _rfidSub = _rfid.onTagRead.listen((epc) {
        final n = _normEpc(epc);
        if (n.isEmpty) return;
        if (!_scannedSet.contains(n)) {
          _scannedSet.add(n);
          HapticFeedback.mediumImpact();
        }
      });
      await _rfid.startScan();
      isScanning.value = true;
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null) {
        await AppDialog.showError(
          ctx,
          title: 'Ошибка RFID',
          message: 'Не удалось запустить считыватель меток.',
          reason: e.toString(),
          solution: 'Убедитесь, что устройство подключено.',
        );
      } else {
        AppSnackbar.showError('RFID', 'Не удалось запустить считыватель');
      }
    }
  }

  Future<void> stopScan() async {
    await _rfid.stopScan();
    await _rfidSub?.cancel();
    _rfidSub = null;
    isScanning.value = false;
  }

  void removeScanned(String epc) {
    _scannedSet.remove(_normEpc(epc));
  }

  void clearAll() {
    _scannedSet.clear();
  }

  Future<void> submit() async {
    if (_scannedSet.isEmpty) {
      AppSnackbar.showError('Ошибка', 'Отсканируйте хотя бы один объект');
      return;
    }
    if (isSending.value) return;
    isSending.value = true;
    try {
      final movementId = int.tryParse(task.movementId) ?? 0;
      if (movementId == 0) {
        AppSnackbar.showError('Ошибка', 'Неверный ID перемещения');
        isSending.value = false;
        return;
      }
      final list = _scannedSet.toList();
      final result = await _service.movementBatch(
        movementId: movementId,
        scannedEpcs: list,
      );
      if (result.success) {
        final msg = 'Перемещено: ${result.movedCount}';
        if (result.unknownEpcs.isNotEmpty) {
          AppSnackbar.showInfo('Внимание', '$msg. Неизвестные метки: ${result.unknownEpcs.length}');
        } else if (result.notInSource.isNotEmpty) {
          AppSnackbar.showInfo('Внимание', '$msg. Не в исходной локации: ${result.notInSource.length}');
        } else {
          AppSnackbar.showSuccess('Готово', msg);
        }
        _scannedSet.clear();
        Get.back();
      } else {
        AppSnackbar.showError('Ошибка', result.message ?? 'Не удалось выполнить перемещение');
      }
    } catch (e) {
      AppSnackbar.showError('Ошибка', e.toString());
    } finally {
      isSending.value = false;
    }
  }
}
