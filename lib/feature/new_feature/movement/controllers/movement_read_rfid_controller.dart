import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/api/api_client.dart';
import '../../rfid/rfid_bus.dart';
import '../../rfid/rfid_session.dart';
import '../models/movement_item.dart';
import '../models/movement_task_model.dart';

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

  @override
  void onInit() {
    super.onInit();

    RfidSession.instance.currentMode = RfidMode.movement;

    _sub = RfidBus.instance.stream.listen(_onTagRead);
  }

  Future<void> _onTagRead(String epc) async {
    if (_scanned.contains(epc)) return;
    _scanned.add(epc);

    readCount.value++;

    final ok = await ApiClient().sendTagRequest(
      endpoint: 'api/process_movement_tsd.php',
      body: {
        'movement_id': task.movementId,
        'item_id': items.first.id,
        'rfid': epc,
        'status': '2',
      },
    );

    if (!ok) return;

    moved.value++;
    notMoved.value = total.value - moved.value;
  }

  Future<bool> sendMovement(String epc, MovementItem item) async {
    return ApiClient().sendTagRequest(
      endpoint: 'api/process_movement_tsd.php',
      body: {
        'movement_id': item.movementId,
        'item_id': item.id,
        'rfid': epc,
        'status': '2',
      },
    );
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
