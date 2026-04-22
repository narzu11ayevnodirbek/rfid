import 'package:get/get.dart';
import 'package:rf_id_test/core/base/local_source.dart';
import '../../../../../injector_container.dart';
import '../../../../injector_container.dart';
import '../models/inventory_task_model.dart';
import '../services/inventory_service.dart';

class InventoryTaskController extends GetxController {
  InventoryTaskController(this.inventoryId);

  final String inventoryId;
  RxList<InventoryTaskModel> items = <InventoryTaskModel>[].obs;
  RxBool isLoading = false.obs;
  final LocalSource _localSource = sl<LocalSource>();

  late final InventoryService _service;

  @override
  void onInit() {
    super.onInit();
    _service = InventoryService(_localSource);
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    items.value = await _service.getInventoryTask(inventoryId);
    isLoading.value = false;
  }

  void markItemAsFound() {
    try {
      final idx = items.indexWhere((e) => e.found < e.total);

      if (idx != -1) {
        items[idx].found++;
        items.refresh();
      }
    } catch (e) {
      print('markItemAsFound error: $e');
    }
  }
}
