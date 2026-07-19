import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/base/local_source.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/base/local_source.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../rfid/rfid_bus.dart';
import '../../utils/app_snackbar.dart';
import '../models/inventory_item.dart';
import '../models/inventory_model.dart';
import '../models/inventory_task_model.dart';
import '../services/inventory_service.dart';

class InventoryController extends GetxController {
  RxBool lastScanSuccess = false.obs;

  final RxSet<String> _buffer = <String>{}.obs;
  Timer? _flushTimer;

  RxList<InventoryModel> inventories = <InventoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;

  bool _scanActive = false;
  // final Set<String> _sentTags = {};

  final LocalSource _localSource = sl<LocalSource>();
  late final InventoryService _service;

  RxList<String> scannedTags = <String>[].obs;
  /// ID единиц, по которым нажали «Завершить» — зелёные, не открывать снова
  final RxList<String> completedItemIds = <String>[].obs;
  RxString selectedInventoryId = ''.obs;
  RxString selectedTaskId = ''.obs;

  @override
  void onInit() {
    super.onInit();

    RfidBus.instance.stream.listen((epc) {
      print('🔥 FLUTTER RECEIVED EPC → $epc');
    });

    _service = InventoryService(_localSource);
    fetchInventories();

    RfidBus.instance.stream.listen(_onTagRead);

    _flushTimer = Timer.periodic(
      const Duration(milliseconds: 800),
      (_) => _flushBuffer(),
    );
  }

  void startScan() {
    _scanActive = true;
    lastScanSuccess.value = false; // сброс, чтобы не показывать "прочитано" до реального чтения
    _buffer.clear();
  }

  Future<void> _flushBuffer() async {
    if (_buffer.isEmpty) return;
    if (!_scanActive) return;

    final tags = List<String>.from(_buffer);
    _buffer.clear();

    for (final epc in tags) {


    }
  }

  void stopScan() {
    _scanActive = false;
  }

  void _onTagRead(String epc) {
    print('🟡 _onTagRead CALLED: $epc');

    if (!_scanActive) return;
    if (!scannedTags.contains(epc)) {
      scannedTags.add(epc);
      AppSnackbar.showInfo('RFID', 'Метка считана: $epc');
    }

    _buffer.add(epc);
    lastScanSuccess.value = true;


    print('🟢 BUFFER SIZE: ${_buffer.length}');
  }

  Future<void> fetchInventories() async {
    isLoading.value = true;
    try {
      inventories.value = await _service.getInventories();
    } catch (e) {
      print('❌ fetchInventories error: $e');
      inventories.value = [];
      AppSnackbar.showError('Ошибка', 'Не удалось загрузить список. Проверьте сеть и авторизацию.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshInventories() async {
    isRefreshing.value = true;
    try {
      inventories.value = await _service.getInventories();
      AppSnackbar.showSuccess('Обмен', 'Информация обновлена');
    } catch (_) {
      AppSnackbar.showError('Ошибка', 'Проблема с Интернетом или API');
    }
    isRefreshing.value = false;
  }

  Future<void> sendTagToServer(String epc, {required String status}) async {
    await ApiClient().sendTagRequest(
      endpoint: 'api/process_tsd_scan.php',
      body: {
        'inventory_id': selectedInventoryId.value,
        'rfid': epc,
        'status': status,
      },
    );

    await _writeLocalLog(epc, status);
  }

  Future<void> _writeLocalLog(String epc, String status) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/rfid_log.txt');

      final time = DateTime.now().toIso8601String();
      final line = '$time | EPC=$epc | STATUS=$status\n';

      await file.writeAsString(
        line,
        mode: FileMode.append,
        flush: true,
      );

      print('📂 LOG DIR: ${dir.path}');
      print('📄 LOG WRITTEN: $line');
    } catch (e) {
      print('❌ LOG WRITE ERROR: $e');
    }
  }

  @override
  void onClose() {
    _flushTimer?.cancel();
    super.onClose();
  }

  void markItemAsFoundCounter(String epc) {
    try {
      if (!scannedTags.contains(epc)) {
        scannedTags.add(epc);

        final inv = inventories.firstWhere(
          (e) => e.id == selectedInventoryId.value,
        );

        inv.found++;
        inv.notFound = inv.total - inv.found;

        inventories.refresh();
      }
    } catch (e) {
      print('markItemAsFoundCounter error: $e');
    }
  }

  Future<bool> finishItem({
    required String taskId,
    required InventoryItem item,
    required String epc,
  }) async {
    final ok = await ApiClient().sendTagRequest(
      endpoint: 'api/process_tsd_scan.php',
      body: {
        'inventory_id': selectedInventoryId.value,
        'task_id': taskId,
        'rfid': epc,
        'item_id': item.id,
        'status': '2',
      },
    );

    if (ok) {
      scannedTags.add(epc);
      completedItemIds.add(item.id);
      print('🟢 ITEM CLOSED → ${item.id}');
    }
    return ok;
  }

  /// Отправка всех считанных меток для выбранной инвентаризации/задачи.
  Future<bool> finishTaskScan({required InventoryTaskModel task}) async {
    if (scannedTags.isEmpty) {
      AppSnackbar.showError('Ошибка', 'Нет считанных меток для отправки');
      return false;
    }
    try {
      final invId = int.tryParse(task.inventoryId) ?? int.tryParse(selectedInventoryId.value) ?? 0;
      if (invId == 0) {
        AppSnackbar.showError('Ошибка', 'Не указан ID инвентаризации');
        return false;
      }
      final ok = await _service.finishInventory(
        inventoryId: invId,
        scannedItems: scannedTags.toList(),
        durationSeconds: 0,
        deviceId: 'MOBILE-TASK',
      );
      if (ok) {
        AppSnackbar.showSuccess('Инвентаризация', 'Метки отправлены на сервер');
        scannedTags.clear();
      } else {
        AppSnackbar.showError('Ошибка', 'Сервер не принял результаты');
      }
      return ok;
    } catch (e) {
      AppSnackbar.showError('Ошибка', 'Не удалось отправить результаты: $e');
      return false;
    }
  }

}
