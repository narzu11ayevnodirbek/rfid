import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/api/api_client.dart';
import '../../rfid/rfid_bus.dart';
import '../../rfid/rfid_session.dart';
import '../models/marking_task_model.dart';

class MarkingReadRfidController extends GetxController {
  MarkingReadRfidController(this.task);

  final MarkingTaskModel task;

  RxBool isReading = false.obs;

  late final RxInt total = task.itemsCount.obs;
  late final RxInt marked = task.markedCount.obs;
  late final RxInt notMarked = (task.itemsCount - task.markedCount).obs;
  RxInt readCount = 0.obs;

  RxInt powerStep = 5.obs;

  final Set<String> _scanned = {};
  late final StreamSubscription<String> _sub;

  @override
  void onInit() {
    super.onInit();

    RfidSession.instance.currentMode = RfidMode.marking;

    _sub = RfidBus.instance.stream.listen(_onTagRead);
  }

  Future<void> _onTagRead(String epc) async {
    if (_scanned.contains(epc)) return;
    _scanned.add(epc);

    readCount.value++;

    final ok = await _bindTag(epc);
    if (ok) {
      marked.value++;
      notMarked.value = total.value - marked.value;
    }
  }

  Future<bool> _bindTag(String epc) async {
    return ApiClient().sendTagRequest(
      endpoint: 'api/bind_rfid_to_item.php',
      body: {
        'item_id': task.id,
        'epc': epc,
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
