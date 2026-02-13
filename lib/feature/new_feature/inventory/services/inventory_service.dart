import 'package:dio/dio.dart';
import 'package:rf_id_test/core/base/local_source.dart';
import 'package:rf_id_test/injector_container.dart';
import '../../../../core/api/api_client.dart';
import '../models/inventory_item.dart';
import '../models/inventory_model.dart';
import '../models/inventory_task_model.dart';

class InventoryService {
  InventoryService(this.localSource);

  final Dio _dio = sl<Dio>();
  final LocalSource localSource;

  Future<List<InventoryModel>> getInventories() async {
    try {
      final response = await _dio.get(
        'api/inventory.php',
        options: optionsWithBearer(),
      );

      if (response.data is Map && response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((e) => InventoryModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getInventories error: ${e.response?.data}');
      rethrow;
    }
  }

  Future<List<InventoryTaskModel>> getInventoryTask(String id) async {
    try {
      final response = await _dio.get(
        'api/inventory_tasks.php',
        queryParameters: {'inventory_id': id},
        options: optionsWithBearer(),
      );

      if (response.data is Map && response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((e) => InventoryTaskModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('❌ getInventoryTask error: ${e.response?.data}');
      rethrow;
    }
  }

  Future<bool> closeInventoryTask(String taskId, String epc) async {
    try {
      final bool result = await ApiClient().sendTagRequest(
        endpoint: 'api/process_tsd_scan.php',
        body: {
          'inventory_id': taskId,
          'rfid': epc,
          'status': '2',
        },
      );

      return result;
    } catch (e) {
      print('❌ closeInventoryTask error: $e');
      return false;
    }
  }

  Future<List<InventoryItem>> getInventoryItems({
    required int inventoryId,
  }) async {
    final response = await _dio.get(
      'api/get_inventory_items_for_tsd.php',
      queryParameters: {
        'inventory_id': inventoryId,
      },
    );

    if (response.data is Map && response.data['success'] == true) {
      final data = response.data['data'];

      final List tasks = data['tasks'];

      final List<InventoryItem> items = [];

      for (final task in tasks) {
        final List taskItems = task['items'];

        for (final item in taskItems) {
          items.add(InventoryItem.fromJson(item));
        }
      }

      return items;
    }

    return [];
  }
}
