import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/rfid/rfid_bus.dart';
import 'package:rf_id_test/feature/new_feature/rfid/rfid_service.dart';

class RfidController extends GetxController {
  final RfidService _service = RfidService();

  RxString lastTag = ''.obs;
  bool _inited = false;

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
}
