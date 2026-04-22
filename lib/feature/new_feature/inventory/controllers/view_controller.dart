import 'package:get/get.dart';

import '../models/tag_model.dart';
import '../services/items_service.dart';
import '../../rfid/rfid_service.dart';
import '../../utils/app_snackbar.dart';

class ViewController extends GetxController {
  final RfidService _rfid = RfidService();
  final ItemsService _itemsService = ItemsService();

  RxBool isReading = false.obs;
  RxList<TagModel> foundItems = <TagModel>[].obs;

  List<TagModel> _allItems = [];

  @override
  void onInit() {
    super.onInit();
    _loadItems();

    _rfid.onTagRead.listen((epc) {
      _onTagRead(epc);
    });
  }

  Future<void> _loadItems() async {
    try {
      _allItems = await _itemsService.fetchItems();
    } catch (e) {
      AppSnackbar.showError('Ошибка', 'Не удалось загрузить объекты');
    }
  }

  Future<void> start() async {
    if (isReading.value) return;
    try {
      await _rfid.init();
      await _rfid.startScan();
      isReading.value = true;
    } catch (e) {
      AppSnackbar.showError('RFID', 'Не удалось запустить считыватель');
    }
  }

  Future<void> stop() async {
    await _rfid.stopScan();
    isReading.value = false;
  }

  Future<void> toggle() async {
    if (isReading.value) {
      await stop();
    } else {
      await start();
    }
  }

  void _onTagRead(String epc) {
    if (!isReading.value) return;

    // Пытаемся найти объект по rfid
    final found = _allItems.firstWhereOrNull(
      (item) => item.rfid.isNotEmpty && item.rfid == epc,
    );

    if (found == null) return;

    if (foundItems.indexWhere((e) => e.id == found.id) == -1) {
      foundItems.add(found);
      AppSnackbar.showInfo('RFID', 'Найден объект: ${found.name}');
    }
  }
}

