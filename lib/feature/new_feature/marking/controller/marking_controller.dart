import 'package:get/get.dart';
import 'package:rf_id_test/core/base/local_source.dart';
import 'package:rf_id_test/feature/new_feature/marking/models/marking_model.dart';
import 'package:rf_id_test/feature/new_feature/marking/services/marking_service.dart';
import '../../../../core/api/api_client.dart';
import '../../../../injector_container.dart';
import '../../rfid/rfid_bus.dart';

class MarkingController extends GetxController {
  RxString selectedMarkingId = ''.obs;

  RxList<MarkingModel> markings = <MarkingModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;

  final LocalSource _localSource = sl<LocalSource>();
  late final MarkingService _service;

  RxList<String> tags = <String>[].obs;
  final Set<String> _sentTags = {};

  RxString currentTaskId = ''.obs;
  RxString currentItemId = ''.obs;
  RxList<String> scannedTags = <String>[].obs;

  @override
  void onInit() {
    _service = MarkingService(_localSource);
    fetchMarkings();

    RfidBus.instance.stream.listen(_onTagRead);

    super.onInit();
  }

  void startScan({
    required String markingId,
    required String taskId,
    required String itemId,
  }) {
    selectedMarkingId.value = markingId;
    currentTaskId.value = taskId;
    currentItemId.value = itemId;

    scannedTags.clear();
    _sentTags.clear();
  }

  Future<void> _onTagRead(String epc) async {
    if (selectedMarkingId.value.isEmpty) return;
    if (_sentTags.contains(epc)) return;

    _sentTags.add(epc);
    scannedTags.add(epc);

    await ApiClient().sendTagRequest(
      endpoint: 'api/process_marking_scan.php',
      body: {
        'marking_id': selectedMarkingId.value,
        'task_id': currentTaskId.value,
        'item_id': currentItemId.value,
        'rfid': epc,
        'status': '2',
      },
    );
  }

  Future<void> fetchMarkings() async {
    isLoading.value = true;
    markings.value = await _service.getMarkings();
    isLoading.value = false;
  }

  Future<void> refreshMarkings() async {
    isRefreshing.value = true;
    try {
      markings.value = await _service.getMarkings();
      Get.snackbar('Обмен', 'Информация обновлена');
    } catch (_) {
      Get.snackbar('Xatolik', 'Проблемa API bilan');
    }
    isRefreshing.value = false;
  }
}
