import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rfid/core/base/local_source.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../rfid/rfid_bus.dart';
import '../../rfid/rfid_service.dart';
import '../../utils/app_dialog.dart';
import '../../utils/app_snackbar.dart';
import '../models/inventory_plan_model.dart';
import '../services/inventory_service.dart';

/// Контроллер режима сканирования инвентаризации по ТЗ:
/// — Загрузка плана (GET), кэш в файл.
/// — HashSet для дедупликации EPC в одной сессии.
/// — Сравнение план/факт: Match (подтверждено), Missing (недостача), Extra (излишек).
/// — Мощность антенны на максимум (30 dBm).
/// — Звуковая индикация: новая метка / чужая метка.
/// — Сохранить черновик, Завершить с проверкой «пустое сканирование».
class InventoryScanController extends GetxController {
  InventoryScanController({
    required this.inventoryId,
    required this.inventoryName,
  });

  final int inventoryId;
  final String inventoryName;

  final RfidService _rfid = RfidService();
  late final InventoryService _service = InventoryService(sl<LocalSource>());

  /// План с сервера (или из кэша).
  final Rx<InventoryPlanModel?> plan = Rx<InventoryPlanModel?>(null);
  final RxBool planLoading = true.obs;
  final RxString planError = ''.obs;

  /// Уникальные считанные EPC в этой сессии (HashSet по ТЗ).
  final RxSet<String> _scannedSet = <String>{}.obs;
  RxList<String> get scannedList => _scannedSet.toList().obs;

  /// Старт/стоп сканирования.
  final RxBool isScanning = false.obs;
  StreamSubscription<String>? _subscription;

  /// Время старта сессии для duration_seconds.
  DateTime? _sessionStart;

  /// Состояния по плану для UI: confirmed, missing, extra.
  List<ExpectedInventoryItem> get matchItems =>
      plan.value?.expectedItems
          .where((e) => _scannedSet.contains(_normEpc(e.epc)))
          .toList() ??
      [];
  List<ExpectedInventoryItem> get missingItems =>
      plan.value?.expectedItems
          .where((e) => !_scannedSet.contains(_normEpc(e.epc)))
          .toList() ??
      [];
  /// EPC, считанные, но не из плана (излишек).
  List<String> get extraEpcs {
    final planEpcs =
        plan.value?.expectedItems.map((e) => _normEpc(e.epc)).toSet() ?? {};
    return _scannedSet.where((epc) => !planEpcs.contains(epc)).toList();
  }

  int get totalCount => plan.value?.expectedItems.length ?? 0;
  int get foundCount => matchItems.length;
  int get missingCount => missingItems.length;
  int get extraCount => extraEpcs.length;

  final RxBool isSending = false.obs;
  final RxBool draftSaved = false.obs;

  StreamSubscription? _rfidSubscription;

  static String _normEpc(String epc) => epc.trim().toUpperCase();

  @override
  void onInit() {
    super.onInit();
    loadPlan();
    _restoreDraft();
    _subscription = RfidBus.instance.stream.listen(_onTagRead);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _rfidSubscription?.cancel();
    _rfid.stopScan();
    super.onClose();
  }

  Future<void> loadPlan() async {
    planLoading.value = true;
    planError.value = '';
    try {
      final p = await _service.getPlan(inventoryId);
      plan.value = p;
      if (p == null || p.expectedItems.isEmpty) {
        planError.value = 'План пуст или не получен';
      } else {
        await _savePlanCache(p);
      }
    } catch (e) {
      planError.value = 'Ошибка загрузки: $e';
      final cached = await _loadPlanCache();
      if (cached != null) {
        plan.value = cached;
        planError.value = '';
        AppSnackbar.showInfo('Кэш', 'Используются сохранённые данные плана');
      }
    } finally {
      planLoading.value = false;
    }
  }

  Future<void> _savePlanCache(InventoryPlanModel p) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/inventory_plan_$inventoryId.json');
      await f.writeAsString(jsonEncode({
        'inventory_id': p.inventoryId,
        'location_name': p.locationName,
        'expected_items': p.expectedItems.map((e) => {'epc': e.epc, 'name': e.name}).toList(),
      }), flush: true);
    } catch (_) {}
  }

  Future<InventoryPlanModel?> _loadPlanCache() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/inventory_plan_$inventoryId.json');
      if (!await f.exists()) return null;
      final map = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      return InventoryPlanModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> _restoreDraft() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/inventory_draft_$inventoryId.json');
      if (!await f.exists()) return;
      final map = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      final list = map['scanned_items'] as List?;
      if (list != null) {
        for (final e in list) {
          _scannedSet.add(_normEpc(e.toString()));
        }
      }
    } catch (_) {}
  }

  /// Сохранить черновик (ТЗ: Partial Save).
  Future<void> saveDraft() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/inventory_draft_$inventoryId.json');
      await f.writeAsString(jsonEncode({
        'inventory_id': inventoryId,
        'scanned_items': _scannedSet.toList(),
        'saved_at': DateTime.now().toIso8601String(),
      }), flush: true);
      draftSaved.value = true;
      AppSnackbar.showSuccess('Черновик', 'Сохранён. Можно продолжить позже.');
    } catch (e) {
      AppSnackbar.showError('Ошибка', 'Не удалось сохранить черновик');
    }
  }

  void _onTagRead(String epc) {
    if (!isScanning.value) return;
    final n = _normEpc(epc);
    if (n.isEmpty) return;
    final isNew = !_scannedSet.contains(n);
    _scannedSet.add(n);

    final planEpcs =
        plan.value?.expectedItems.map((e) => _normEpc(e.epc)).toSet() ?? {};
    final isExtra = !planEpcs.contains(n);

    if (isNew) {
      if (isExtra) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.mediumImpact();
      }
    }
  }

  /// Мощность на максимум (ТЗ: например 30 dBm).
  Future<void> setPowerMax() async {
    await _rfid.setPower(30);
  }

  Future<void> startScan() async {
    if (isScanning.value) return;
    try {
      await _rfid.init();
      await setPowerMax();
      await _rfidSubscription?.cancel();
      _rfidSubscription = _rfid.onTagRead.listen(_onTagRead);
      await _rfid.startScan();
      isScanning.value = true;
      _sessionStart ??= DateTime.now();
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null) {
        await AppDialog.showError(
          ctx,
          title: 'Ошибка RFID',
          message: 'Не удалось запустить считыватель меток.',
          reason: e.toString(),
          solution: 'Убедитесь, что устройство подключено и разрешения выданы. Перезапустите приложение при необходимости.',
        );
      } else {
        AppSnackbar.showError('RFID', 'Не удалось запустить считыватель: $e');
      }
    }
  }

  Future<void> stopScan() async {
    await _rfid.stopScan();
    await _rfidSubscription?.cancel();
    _rfidSubscription = null;
    isScanning.value = false;
  }

  /// Завершить инвентаризацию: проверка пустого сканирования, затем POST.
  Future<void> finish({required Future<void> Function() onSuccess}) async {
    if (isSending.value) return;

    if (_scannedSet.isEmpty) {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Пустое сканирование'),
          content: const Text(
            'Вы не считали ни одного объекта. Уверены, что хотите закончить?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Да, завершить'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    isSending.value = true;
    try {
      final duration = _sessionStart != null
          ? DateTime.now().difference(_sessionStart!).inSeconds
          : 0;
      final ok = await _service.finishInventory(
        inventoryId: inventoryId,
        scannedItems: _scannedSet.toList(),
        durationSeconds: duration,
        deviceId: 'TSD',
      );
      if (ok) {
        await _clearDraft();
        await onSuccess();
      } else {
        final ctx = Get.context;
        if (ctx != null) {
          await AppDialog.showError(
            ctx,
            title: 'Ошибка отправки итогов',
            message: 'Сервер не принял результаты инвентаризации.',
            reason: 'Возможны проблемы с сетью или авторизацией.',
            solution: 'Проверьте интернет и повторите попытку. Черновик сохранён — можно отправить позже.',
          );
        } else {
          AppSnackbar.showError('Ошибка', 'Сервер не принял итоги');
        }
      }
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null) {
        await AppDialog.showError(
          ctx,
          title: 'Ошибка синхронизации',
          message: 'Не удалось отправить данные на сервер.',
          reason: e.toString(),
          solution: 'Черновик сохранён. Отправьте итоги позже при появлении сети через кнопку «Завершить».',
        );
      } else {
        AppSnackbar.showError('Ошибка синхронизации', 'Данные можно отправить позже при появлении сети.');
      }
      await saveDraft();
    } finally {
      isSending.value = false;
    }
  }

  Future<void> _clearDraft() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/inventory_draft_$inventoryId.json');
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
