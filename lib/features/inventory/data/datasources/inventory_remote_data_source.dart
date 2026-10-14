import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/inventory/data/models/inventory_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_plan_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_task_model.dart';

/// Inventory requests. See `docs/API.md` for the exact shapes.
class InventoryRemoteDataSource {
  const InventoryRemoteDataSource(this._api);

  /// Sent as `device_id` so the server knows the result came from a handheld.
  static const String _deviceId = 'TSD';

  final ApiClient _api;

  /// `GET api/inventory.php`
  Future<List<InventoryModel>> getInventories() async {
    final json = await _api.get(ApiEndpoints.inventories);
    return JsonReader(json)
        .mapList('data')
        .map(InventoryModel.fromJson)
        .toList();
  }

  /// `GET api/inventory_tasks.php?inventory_id=`
  Future<List<InventoryTaskModel>> getTasks(String inventoryId) async {
    final json = await _api.get(
      ApiEndpoints.inventoryTasks,
      query: {'inventory_id': inventoryId},
    );
    return JsonReader(json)
        .mapList('data')
        .map(InventoryTaskModel.fromJson)
        .toList();
  }

  /// `GET api/inventory_get_plan.php?id=`
  Future<InventoryPlanModel> getPlan(String inventoryId) async {
    final json = await _api.get(
      ApiEndpoints.inventoryPlan,
      query: {'id': inventoryId},
    );
    return InventoryPlanModel.fromJson(json, inventoryId: inventoryId);
  }

  /// `POST api/inventory_finish.php`
  Future<void> finishInventory({
    required String inventoryId,
    required List<String> scannedEpcs,
    required Duration duration,
  }) async {
    await _api.post(
      ApiEndpoints.inventoryFinish,
      body: {
        // The server expects a number here, as the legacy app sent it.
        'inventory_id': int.tryParse(inventoryId) ?? inventoryId,
        'scanned_items': scannedEpcs,
        'duration_seconds': duration.inSeconds,
        'device_id': _deviceId,
      },
    );
  }
}
