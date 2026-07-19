import 'package:dio/dio.dart';
import 'package:rfid/core/base/local_source.dart';
import 'package:rfid/infrastructure/di/injector_container.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../core/api/api_client.dart';
import '../models/inventory_item.dart';
import '../models/inventory_model.dart';
import '../models/inventory_plan_model.dart';
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

  /// ТЗ: GET /api/inventory/{id} — загрузка задания на инвентаризацию.
  /// Ответ: inventory_id, location_name, expected_items: [{ epc, name }].
  Future<InventoryPlanModel?> getPlan(int inventoryId) async {
    try {
      final response = await _dio.get(
        'api/inventory_get_plan.php',
        queryParameters: {'id': inventoryId},
        options: optionsWithBearer(),
      );
      if (response.data is Map && response.data['success'] == true) {
        return InventoryPlanModel.fromJson(
            Map<String, dynamic>.from(response.data as Map));
      }
      return null;
    } on DioException catch (e) {
      print('❌ getPlan error: ${e.response?.data}');
      rethrow;
    }
  }

  /// ТЗ: POST /api/inventory/{id}/finish — отправка итогов (JSON).
  /// Payload: inventory_id, scanned_items, duration_seconds, device_id.
  Future<bool> finishInventory({
    required int inventoryId,
    required List<String> scannedItems,
    required int durationSeconds,
    String deviceId = '',
  }) async {
    try {
      final response = await _dio.post(
        'api/inventory_finish.php',
        data: {
          'inventory_id': inventoryId,
          'scanned_items': scannedItems,
          'duration_seconds': durationSeconds,
          'device_id': deviceId,
        },
        options: optionsWithBearer(),
      );
      return response.data is Map && response.data['success'] == true;
    } on DioException catch (e) {
      print('❌ finishInventory error: ${e.response?.data}');
      rethrow;
    }
  }
}
