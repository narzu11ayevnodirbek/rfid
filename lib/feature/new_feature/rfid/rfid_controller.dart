import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/rfid/rfid_bus.dart';
import 'package:rf_id_test/feature/new_feature/rfid/rfid_service.dart';
// import 'package:rf_id_test/feature/new_feature/rfid/rfid_bus.dart';
// import 'package:rf_id_test/feature/new_feature/rfid/rfid_service.dart';

class RfidController extends GetxController {
  final RfidService _service = RfidService();

  RxString lastTag = ''.obs;
  bool _inited = false;
  /// Текущий уровень мощности (1–10 шагов, умножаем на 3 для dBm).
  final RxInt powerStep = 10.obs;

  @override
  void onInit() {
    super.onInit();

    _service.onTagRead.listen((epc) {
      print('📥 EPC FROM ANDROID → $epc');
      RfidBus.instance.broadcast(epc);
    });
  }

  Future<void> initOnce() async {
    if (_inited) return;
    await _service.init();
    _inited = true;
  }

  Future<void> init() async => _service.init();

  Future<void> start() async => _service.startScan();

  Future<void> stop() async => _service.stopScan();

  /// Ручная установка мощности считывателя.
  /// [step] от 1 до 10, фактический уровень = step * 3.
  Future<void> setPowerStep(int step) async {
    int value = step;
    if (value < 1) value = 2;
    if (value > 10) value = 10;
    powerStep.value = step;
    await _service.setPower(step * 3);
  }
}
