import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rfid/feature/new_feature/rfid/rfid_service.dart';
import 'package:rfid/feature/new_feature/utils/app_dialog.dart';
import 'package:rfid/feature/new_feature/utils/app_snackbar.dart';
import 'package:rfid/feature/new_feature/movement/models/location_model.dart';
import 'package:rfid/feature/new_feature/movement/services/transfer_service.dart';

class FreeTransferController extends GetxController {
  final TransferService _service = TransferService();
  final RfidService _rfid = RfidService();

  RxList<LocationModel> locations = <LocationModel>[].obs;
  RxBool locationsLoading = true.obs;
  Rx<LocationModel?> selectedLocation = Rx<LocationModel?>(null);

  final RxSet<String> _scannedSet = <String>{}.obs;

  int get scannedCount => _scannedSet.length;

  List<String> get scannedItems => _scannedSet.toList();

  RxBool isScanning = false.obs;
  RxBool isSending = false.obs;
  StreamSubscription? _rfidSub;

  static String _normEpc(String e) => e.trim().toUpperCase();

  @override
  void onInit() {
    super.onInit();
    loadLocations();
  }

  @override
  void onClose() {
    _rfidSub?.cancel();
    _rfid.stopScan();
    super.onClose();
  }

  Future<void> loadLocations() async {
    locationsLoading.value = true;
    try {
      locations.value = await _service.getLocations();
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null) {
        await AppDialog.showError(
          ctx,
          title: 'Ошибка загрузки локаций',
          message: 'Не удалось загрузить список локаций для выбора.',
          reason: e.toString(),
          solution: 'Проверьте подключение к интернету и авторизацию. Повторите попытку или обновите страницу.',
        );
      } else {
        AppSnackbar.showError('Ошибка', 'Не удалось загрузить список локаций');
      }
      locations.value = [];
    } finally {
      locationsLoading.value = false;
    }
  }

  Future<void> setPowerMedium() async {
    await _rfid.setPower(18);
  }

  Future<void> startScan() async {
    if (isScanning.value) return;
    try {
      await _rfid.init();
      await setPowerMedium();
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
          solution:
              'Убедитесь, что устройство подключено. Чтение выполняется только при нажатии физической кнопки на считывателе.',
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

  void clearScanned() {
    _scannedSet.clear();
  }

  void removeScanned(String epc) {
    _scannedSet.remove(_normEpc(epc));
  }

  Future<void> submit({int userId = 0}) async {
    final ctx = Get.context;
    if (selectedLocation.value == null) {
      if (ctx != null) {
        await AppDialog.showError(
          ctx,
          title: 'Не выбрана локация',
          message: 'Укажите, куда перемещаются объекты.',
          solution: 'Выберите локацию из списка «Куда перемещаем?» выше.',
        );
      } else {
        AppSnackbar.showError('Ошибка', 'Выберите локацию');
      }
      return;
    }
    if (_scannedSet.isEmpty) {
      if (ctx != null) {
        await AppDialog.showError(
          ctx,
          title: 'Нет объектов для перемещения',
          message: 'Не отсканировано ни одной метки.',
          solution: 'Нажмите «Сканировать», затем читайте метки, нажимая физическую кнопку на считывателе.',
        );
      } else {
        AppSnackbar.showError('Ошибка', 'Отсканируйте хотя бы один объект');
      }
      return;
    }
    if (isSending.value) return;
    isSending.value = true;
    try {
      final result = await _service.freeTransfer(
        newLocationId: selectedLocation.value!.id,
        scannedEpcs: _scannedSet.toList(),
        userId: userId,
      );
      if (result.success) {
        if (result.movedCount > 0) {
          AppSnackbar.showSuccess('Перемещение', 'Перемещено объектов: ${result.movedCount}');
          clearScanned();
        }
        if (result.unknownEpcs.isNotEmpty && ctx != null) {
          await AppDialog.showError(
            ctx,
            title: 'Неизвестный объект',
            message: 'Часть считанных меток не найдена в базе системы.',
            reason: 'Метки не привязаны к объектам или считаны с ошибкой.',
            solution:
                'Проверьте маркировку объектов. EPC: ${result.unknownEpcs.take(3).join(", ")}${result.unknownEpcs.length > 3 ? "..." : ""}',
          );
        } else if (result.unknownEpcs.isNotEmpty) {
          AppSnackbar.showError('Неизвестный объект', 'Метка не в базе. EPC: ${result.unknownEpcs.take(2).join(", ")}');
        }
        if (result.alreadyHere.isNotEmpty) {
          AppSnackbar.showInfo(
              'Объект уже здесь', 'Объект числится в этой локации: ${result.alreadyHere.take(2).join(", ")}');
        }
        if (result.blocked.isNotEmpty && ctx != null) {
          await AppDialog.showError(
            ctx,
            title: 'Объект заблокирован',
            message: 'Часть объектов не может быть перемещена из-за статуса (например, списан, в ремонте).',
            solution: 'Проверьте статус объектов в учёте. Перемещение возможно только для активных объектов.',
          );
        } else if (result.blocked.isNotEmpty) {
          AppSnackbar.showError('Заблокирован', 'Объект в статусе, не допускающем перемещение.');
        }
      } else {
        if (ctx != null) {
          await AppDialog.showError(
            ctx,
            title: 'Ошибка перемещения',
            message: result.message ?? 'Не удалось выполнить перемещение.',
            reason: 'Сервер отклонил запрос или произошла ошибка сети.',
            solution:
                'Проверьте подключение к интернету и повторите попытку. При повторении ошибки обратитесь к администратору.',
          );
        } else {
          AppSnackbar.showError('Ошибка', result.message ?? 'Не удалось выполнить перемещение');
        }
      }
    } catch (e) {
      if (ctx != null) {
        await AppDialog.showError(
          ctx,
          title: 'Ошибка отправки',
          message: 'Не удалось отправить данные на сервер.',
          reason: e.toString(),
          solution: 'Проверьте подключение к интернету и повторите попытку.',
        );
      } else {
        AppSnackbar.showError('Ошибка', 'Сеть или сервер недоступны');
      }
    } finally {
      isSending.value = false;
    }
  }
}
