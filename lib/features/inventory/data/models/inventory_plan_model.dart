import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/core/rfid/epc.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';

/// [InventoryPlan] as returned by `api/inventory_get_plan.php`:
///
/// ```json
/// { "success": true, "inventory_id": 5, "location_name": "...",
///   "expected_items": [ { "epc": "E280...", "name": "..." } ] }
/// ```
///
/// Also the format of the copy cached on the device ([toJson]).
class InventoryPlanModel extends InventoryPlan {
  const InventoryPlanModel({
    required super.inventoryId,
    required super.locationName,
    required super.expectedItems,
  });

  factory InventoryPlanModel.fromJson(
    JsonMap json, {
    required String inventoryId,
  }) {
    // Accept the fields either at the root or inside `data`.
    final reader = JsonReader(JsonReader(json).mapOrNull('data') ?? json);
    return InventoryPlanModel(
      inventoryId: reader.string('inventory_id', fallback: inventoryId),
      locationName: reader.string('location_name'),
      expectedItems: [
        for (final item in reader.mapList('expected_items'))
          ExpectedItem(
            epc: Epc.normalize(JsonReader(item).string('epc')),
            name: JsonReader(item).string('name'),
          ),
      ],
    );
  }

  factory InventoryPlanModel.fromEntity(InventoryPlan plan) =>
      InventoryPlanModel(
        inventoryId: plan.inventoryId,
        locationName: plan.locationName,
        expectedItems: plan.expectedItems,
      );

  JsonMap toJson() => {
        'inventory_id': inventoryId,
        'location_name': locationName,
        'expected_items': [
          for (final item in expectedItems)
            {'epc': item.epc, 'name': item.name},
        ],
      };
}
