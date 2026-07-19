import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rfid/core/base/local_source.dart';
import 'package:rfid/feature/new_feature/marking/models/marking_model.dart';
import 'package:rfid/feature/new_feature/marking/services/marking_service.dart';
import 'package:rfid/core/api/api_client.dart';
import 'package:rfid/infrastructure/di/injector_container.dart';
import 'package:rfid/feature/new_feature/rfid/rfid_bus.dart';
import 'package:rfid/feature/new_feature/utils/app_snackbar.dart';

class MarkingController extends GetxController {
  RxString selectedMarkingId = ''.obs;

  RxList<MarkingModel> markings = <MarkingModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;

  final LocalSource _localSource = sl<LocalSource>();
  late final MarkingService _service;

  RxList<String> tags = <String>[].obs;

  RxString currentTaskId = ''.obs;
  RxString currentItemId = ''.obs;
  RxList<String> scannedTags = <String>[].obs;

  final RxString lastEpc = ''.obs;

  Future<String> loadItemPhoto({
    required int markingId,
    required String itemId,
  }) {
    return _service.getItemPhoto(markingId: markingId, itemId: itemId);
  }

  final RxBool lastScanSuccess = false.obs;

  final Map<String, String> _lastTagByItemId = {};

  final RxList<String> completedItemIds = <String>[].obs;

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
    lastScanSuccess.value = false;
    lastEpc.value = '';
  }

  void _onTagRead(String epc) {
    if (selectedMarkingId.value.isEmpty) return;
    if (currentItemId.value.isEmpty) return;

    final itemId = currentItemId.value;
    final normalized = epc.trim().toUpperCase();

    final prev = _lastTagByItemId[itemId];
    if (prev == normalized) return;

    _lastTagByItemId[itemId] = normalized;

    lastEpc.value = normalized;

    scannedTags
      ..clear()
      ..add(normalized);

    lastScanSuccess.value = true;

    completedItemIds.remove(itemId);

    AppSnackbar.showRfid(normalized);
  }

  Future<({bool ok, String? errorMessage})> finishMarkingItem(
    String itemId, {
    String? markingId,
    String? taskId,
  }) async {
    String? epc = _lastTagByItemId[itemId];
    if ((epc == null || epc.isEmpty) && scannedTags.isNotEmpty) {
      epc = scannedTags.last;
    }
    if (epc == null || epc.isEmpty) {
      return (ok: false, errorMessage: 'Нет считанной метки для отправки');
    }

    final mid = (markingId != null && markingId.isNotEmpty) ? markingId : selectedMarkingId.value;
    final tid = (taskId != null && taskId.isNotEmpty) ? taskId : currentTaskId.value;
    if (mid.isEmpty) {
      return (ok: false, errorMessage: 'Не указана маркировка. Откройте объект из списка задачи.');
    }

    final body = <String, dynamic>{
      'marking_id': mid,
      'item_id': itemId,
      'rfid': epc,
    };
    if (tid.isNotEmpty) body['task_id'] = tid;

    try {
      final dio = sl<Dio>();
      final response = await dio.post(
        'api/process_marking_scan.php',
        data: body,
        options: optionsWithBearer(),
      );
      final data = response.data;
      if (data is Map && data['success'] == true) {
        completedItemIds.add(itemId);
        return (ok: true, errorMessage: null);
      }
      final msg = data['message'] ?? data['error'] ?? 'Сервер вернул ошибку';
      return (ok: false, errorMessage: msg.toString());
    } on DioException catch (e) {
      String? msg;
      final data = e.response?.data;
      if (data is Map) {
        msg = (data['message'] ?? data['error'] ?? data['recommendation'])?.toString();
      } else if (data is String) {
        msg = data;
      }
      return (ok: false, errorMessage: msg ?? e.message ?? 'Нет связи с сервером');
    }
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
      AppSnackbar.showSuccess('Обмен', 'Информация обновлена');
    } catch (_) {
      AppSnackbar.showError('Ошибка', 'Проблема с API');
    }
    isRefreshing.value = false;
  }
}
