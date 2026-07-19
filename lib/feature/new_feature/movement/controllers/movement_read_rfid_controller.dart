import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:rfid/core/api/api_client.dart';
import 'package:rfid/infrastructure/di/injector_container.dart';
import 'package:rfid/feature/new_feature/rfid/rfid_bus.dart';
import 'package:rfid/feature/new_feature/rfid/rfid_session.dart';
import 'package:rfid/feature/new_feature/movement/models/movement_item.dart';
import 'package:rfid/feature/new_feature/movement/models/movement_task_model.dart';

class MovementReadRfidController extends GetxController {
  MovementReadRfidController(this.task, this.items);

  final MovementTaskModel task;

  final List<MovementItem> items;

  RxBool isReading = false.obs;

  late final RxInt total = task.itemsCount.obs;
  late final RxInt moved = task.movedCount.obs;
  late final RxInt notMoved = (task.itemsCount - task.movedCount).obs;
  RxInt readCount = 0.obs;

  RxInt powerStep = 5.obs;

  final Set<String> _scanned = {};
  late final StreamSubscription<String> _sub;

  String? lastScannedEpc;

  final RxList<String> completedItemIds = <String>[].obs;

  final RxBool lastScanSuccess = false.obs;

  void clearLastScan() {
    lastScannedEpc = null;
    lastScanSuccess.value = false;
  }

  @override
  void onInit() {
    super.onInit();

    RfidSession.instance.currentMode = RfidMode.movement;

    _sub = RfidBus.instance.stream.listen(_onTagRead);
  }

  void _onTagRead(String epc) {
    if (_scanned.contains(epc)) return;
    _scanned.add(epc);
    lastScannedEpc = epc;
    lastScanSuccess.value = true;
    readCount.value++;
  }

  Future<({bool ok, String? errorMessage})> sendMovement(String epc, MovementItem item) async {
    try {
      final dio = sl<Dio>();
      final response = await dio.post(
        'api/process_movement_tsd.php',
        data: {
          'movement_id': item.movementId,
          'item_id': item.id,
          'rfid': epc,
        },
        options: optionsWithBearer(),
      );
      final data = response.data;
      if (data is Map && data['success'] == true) {
        completedItemIds.add(item.id);
        moved.value++;
        notMoved.value = total.value - moved.value;
        return (ok: true, errorMessage: null);
      }
      return (ok: false, errorMessage: data['message']?.toString() ?? 'Ошибка сервера');
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map ? (e.response!.data['message'] ?? e.response!.data['error'])?.toString() : null;
      return (ok: false, errorMessage: msg ?? 'Сервер не принял запрос');
    }
  }

  Future<void> applyPower() async {}

  Future<void> start() async {
    await applyPower();
    isReading.value = true;
  }

  Future<void> stop() async {
    isReading.value = false;
  }

  Future<void> toggle() async {
    isReading.value ? await stop() : await start();
  }

  @override
  void onClose() {
    _sub.cancel();
    RfidSession.instance.currentMode = RfidMode.none;
    super.onClose();
  }
}
