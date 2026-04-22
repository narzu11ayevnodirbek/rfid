import 'dart:async';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/inventory/models/inventory_task_model.dart';
import '../../rfid/rfid_bus.dart';
import '../../rfid/rfid_service.dart';
import '../../rfid/rfid_session.dart';
import '../../utils/app_snackbar.dart';
import '../models/inventory_model.dart';
import '../models/inventory_task_model.dart';
import 'inventory_controller.dart';

class ReadRfidController extends GetxController {
  ReadRfidController(this.inventory, this.task);

  final RfidService _service = RfidService();

  final InventoryModel inventory;
  final InventoryTaskModel task;

  RxBool isReading = false.obs;

  RxInt total = 0.obs;
  RxInt found = 0.obs;
  RxInt notFound = 0.obs;
  RxInt extra = 0.obs;
  RxInt readCount = 0.obs;
  RxInt powerStep = 5.obs;

  @override
  void onInit() {
    super.onInit();

    _service.onTagRead.listen((epc) {
      print('🔥 EPC FROM ANDROID → $epc');
      RfidBus.instance.broadcast(epc);
    });

    RfidSession.instance.currentMode = RfidMode.inventory;



    total.value = inventory.total;
    found.value = inventory.found;
    notFound.value = inventory.notFound;
    extra.value = int.tryParse(inventory.countExcess) ?? 0;
  }

  @override
  void onClose() {
    _service.stopScan();
    if (RfidSession.instance.currentMode != RfidMode.inventory) return;
    RfidSession.instance.currentMode = RfidMode.none;
    super.onClose();
  }

  Future<void> applyPower() async {
    final int level = powerStep.value * 3;
    await _service.setPower(level);
  }

  Future<void> start() async {
    if (isReading.value) return;
    await applyPower();
    isReading.value = true;
  }

  Future<void> stop() async {
    await _service.stopScan();
    isReading.value = false;
  }

  Future<void> toggle() async {
    if (isReading.value) {
      await stop();
    } else {
      await start();
    }
  }

  Future<void> finishTask(String epc) async {
    final inv = Get.find<InventoryController>()..stopScan();

    if (inv.scannedTags.isEmpty) {
      AppSnackbar.showError('Ошибка', 'Нет считанных меток');
      return;
    }

    final lastEpc = inv.scannedTags.last;

    await inv.sendTagToServer(lastEpc, status: '2');
    AppSnackbar.showSuccess('Успешно', 'Данные отправлены в базу');
    Get.back();
  }
}
