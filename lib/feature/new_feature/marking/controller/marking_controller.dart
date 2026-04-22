import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/core/base/local_source.dart';
import 'package:rf_id_test/feature/new_feature/marking/models/marking_model.dart';
import 'package:rf_id_test/feature/new_feature/marking/services/marking_service.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../../../../injector_container.dart';
import '../../rfid/rfid_bus.dart';
import '../../utils/app_snackbar.dart';
import '../models/marking_model.dart';
import '../services/marking_service.dart';

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

  final RxString lastEpc = ''.obs;



  Future<String> loadItemPhoto({
    required int markingId,
    required String itemId,
  }) {
    return _service.getItemPhoto(markingId: markingId, itemId: itemId);
  }

  /// Флаг для UI: тег прочитан на текущем экране единицы
  final RxBool lastScanSuccess = false.obs;

  /// Метки по item_id — отправка на сервер только по кнопке "Завершить"
  final Map<String, String> _lastTagByItemId = {};

  /// Item'ы, по которым уже нажали "Завершить" и запрос ушёл на сервер (для зелёной галочки в списке)
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
    // _sentTags.clear();
    lastScanSuccess.value = false;
    lastEpc.value = '';
  }

  /// Только накапливаем метки; отправка на сервер — по кнопке "Завершить"
  // void _onTagRead(String epc) {
  //   if (selectedMarkingId.value.isEmpty) return;
  //   if (_sentTags.contains(epc)) return;
  //
  //   _sentTags.add(epc);
  //   scannedTags.add(epc);
  //   _lastTagByItemId[currentItemId.value] = epc;
  //   lastScanSuccess.value = true;
  //
  //   // Явно показываем, что метка считана
  //   AppSnackbar.showInfo('RFID', 'Метка считана: $epc');
  // }

  void _onTagRead(String epc) {
    if (selectedMarkingId.value.isEmpty) return;
    if (currentItemId.value.isEmpty) return;

    final itemId = currentItemId.value;
    final normalized = epc.trim().toUpperCase();

    // faqat shu item uchun aynan bir xil EPC qayta kelsa ignore
    final prev = _lastTagByItemId[itemId];
    if (prev == normalized) return;

    // oxirgisini doim yangilaymiz (replace)
    _lastTagByItemId[itemId] = normalized;

    lastEpc.value = normalized;

    // UI: oxirgisi ko‘rinsin
    scannedTags
      ..clear()
      ..add(normalized);

    lastScanSuccess.value = true;

    // agar oldin "completed" bo‘lib qolgan bo‘lsa, yangi scan bilan qayta ochamiz
    completedItemIds.remove(itemId);



    AppSnackbar.showRfid(normalized);

    // ❌ MUHIM: bu yerda finishMarkingItem() CHAQRILMAYDI
  }

  /// Вызвать при нажатии "Завершить" — отправить на сервер последнюю метку по этому item и отметить item как завершённый.
  /// [markingId] и [taskId] можно передать из item — тогда запрос не зависит от вызова startScan.
  /// Возвращает (успех, сообщение об ошибке для показа в диалоге).
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

    final mid = (markingId != null && markingId.isNotEmpty)
        ? markingId
        : selectedMarkingId.value;
    final tid =
        (taskId != null && taskId.isNotEmpty) ? taskId : currentTaskId.value;
    if (mid.isEmpty) {
      return (
        ok: false,
        errorMessage: 'Не указана маркировка. Откройте объект из списка задачи.'
      );
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
        msg = (data['message'] ?? data['error'] ?? data['recommendation'])
            ?.toString();
      } else if (data is String) {
        msg = data;
      }
      return (
        ok: false,
        errorMessage: msg ?? e.message ?? 'Нет связи с сервером'
      );
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
