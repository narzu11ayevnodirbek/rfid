import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../../../../injector_container.dart';
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

  /// Последняя считанная метка — отправка на сервер только по кнопке "Завершить"
  String? lastScannedEpc;

  /// ID единиц, по которым нажали «Завершить» — зелёные, не открывать снова
  final RxList<String> completedItemIds = <String>[].obs;

  /// Флаг для UI: тег прочитан на текущем экране единицы
  final RxBool lastScanSuccess = false.obs;

  /// Сбросить при открытии страницы единицы, чтобы учитывать только чтение на этом экране
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

  /// Только накапливаем метки; отправка на сервер — по кнопке "Завершить"
  void _onTagRead(String epc) {
    if (_scanned.contains(epc)) return;
    _scanned.add(epc);
    lastScannedEpc = epc;
    lastScanSuccess.value = true;
    readCount.value++;
  }

  /// Отправка на сервер; возвращает (успех, сообщение об ошибке для UI).
  Future<({bool ok, String? errorMessage})> sendMovement(String epc, MovementItem item) async {
    try {
      final dio = sl<Dio>();
      // Не передаём status: '2' — задание закрывается только по кнопке «Завершить задание»
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
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.response!.data['error'])?.toString()
          : null;
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
