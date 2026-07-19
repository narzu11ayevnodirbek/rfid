import 'dart:async';
import 'package:get/get.dart';
import 'package:rfid/core/api/api_client.dart';
import 'package:rfid/feature/new_feature/rfid/rfid_bus.dart';
import 'package:rfid/feature/new_feature/rfid/rfid_session.dart';
import 'package:rfid/feature/new_feature/marking/models/marking_task_model.dart';

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
  String? _lastEpc;

  @override
  void onInit() {
    super.onInit();

    RfidSession.instance.currentMode = RfidMode.marking;

    _sub = RfidBus.instance.stream.listen(_onTagRead);
  }

  Future<void> _onTagRead(String epc) async {
    final n = epc.trim().toUpperCase();
    if (_lastEpc == n) return;
    _lastEpc = n;
    if (_scanned.contains(n)) return;
    _scanned.add(n);

    readCount.value++;

    final ok = await _bindTag(n);
    if (ok) {
      marked.value++;
      notMarked.value = total.value - marked.value;
    }
  }

  Future<bool> _bindTag(String epc) async {
    try {
      final ok = await ApiClient().sendTagRequest(
        endpoint: 'api/process_marking_scan.php',
        body: {
          'marking_id': task.markingId,
          'task_id': task.id,
          'item_id': task.id,
          'rfid': epc,
        },
      );
      return ok;
    } catch (_) {
      return false;
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
