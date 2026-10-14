import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/inventory/data/models/inventory_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_plan_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_task_model.dart';

class InventoryRemoteDataSource {
  const InventoryRemoteDataSource(this._api);

  static const String _deviceId = 'TSD';

  final ApiClient _api;

  Future<List<InventoryModel>> getInventories() async {
    final json = await _api.get(ApiEndpoints.inventories);
    return JsonReader(json)
        .mapList('data')
        .map(InventoryModel.fromJson)
        .toList();
  }

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

  Future<InventoryPlanModel> getPlan(String inventoryId) async {
    final json = await _api.get(
      ApiEndpoints.inventoryPlan,
      query: {'id': inventoryId},
    );
    return InventoryPlanModel.fromJson(json, inventoryId: inventoryId);
  }

  Future<void> finishInventory({
    required String inventoryId,
    required List<String> scannedEpcs,
    required Duration duration,
  }) async {
    await _api.post(
      ApiEndpoints.inventoryFinish,
      body: {
        // The server expects a number, as the legacy app sent it.
        'inventory_id': int.tryParse(inventoryId) ?? inventoryId,
        'scanned_items': scannedEpcs,
        'duration_seconds': duration.inSeconds,
        'device_id': _deviceId,
      },
    );
  }
}
