import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/base/local_source.dart';
import '../../../../injector_container.dart';
import '../../rfid/rfid_bus.dart';
import '../models/inventory_item.dart';
import '../models/inventory_model.dart';
import '../services/inventory_service.dart';

class InventoryController extends GetxController {
  RxBool lastScanSuccess = false.obs;

  final RxSet<String> _buffer = <String>{}.obs;
  Timer? _flushTimer;

  RxList<InventoryModel> inventories = <InventoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;

  bool _scanActive = false;
  final Set<String> _sentTags = {};

  final LocalSource _localSource = sl<LocalSource>();
  late final InventoryService _service;

  RxList<String> scannedTags = <String>[].obs;
  RxString selectedInventoryId = ''.obs;

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
    }

    _buffer.add(epc);
    lastScanSuccess.value = true;


    print('🟢 BUFFER SIZE: ${_buffer.length}');
  }

  Future<void> fetchInventories() async {
    isLoading.value = true;
    inventories.value = await _service.getInventories();
    isLoading.value = false;
  }

  Future<void> refreshInventories() async {
    isRefreshing.value = true;
    try {
      inventories.value = await _service.getInventories();
      Get.snackbar('Обмен', 'Информация обновлена');
    } catch (_) {
      Get.snackbar('Ошибка', 'Проблема с Интернетом или API');
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

  Future<void> finishItem({
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

      Get.snackbar('✅ Успешно', 'RFID успешно привязан');

      print('🟢 ITEM CLOSED → ${item.id}');
    } else {
      Get.snackbar('❌ Ошибка', 'Сервер не принял запрос');
    }
  }

}
