/// Модель задания на инвентаризацию по ТЗ (GET /api/inventory/{id}).
/// expected_items — план: EPC и название объекта по локации.
class InventoryPlanModel {
  InventoryPlanModel({
    required this.inventoryId,
    required this.locationName,
    required this.expectedItems,
  });

  factory InventoryPlanModel.fromJson(Map<String, dynamic> json) {
    final list = json['expected_items'];
    final items = (list is List)
        ? (list)
            .map((e) => ExpectedInventoryItem.fromJson(
                e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e)))
            .toList()
        : <ExpectedInventoryItem>[];
    return InventoryPlanModel(
      inventoryId: int.tryParse(json['inventory_id']?.toString() ?? '') ?? 0,
      locationName: json['location_name']?.toString() ?? '',
      expectedItems: items,
    );
  }

  final int inventoryId;
  final String locationName;
  final List<ExpectedInventoryItem> expectedItems;
}

class ExpectedInventoryItem {
  ExpectedInventoryItem({required this.epc, required this.name});

  factory ExpectedInventoryItem.fromJson(Map<String, dynamic> json) =>
      ExpectedInventoryItem(
        epc: (json['epc'] ?? '').toString().trim(),
        name: (json['name'] ?? '').toString(),
      );

  final String epc;
  final String name;
}
