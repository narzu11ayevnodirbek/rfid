import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_task.dart';

class InventoryTaskModel extends InventoryTask {
  const InventoryTaskModel({
    required super.id,
    required super.inventoryId,
    required super.location,
    required super.status,
    required super.employeeName,
    required super.foundCount,
    required super.totalCount,
  });

  factory InventoryTaskModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    final employeeName = [
      reader.string('last_name'),
      reader.string('first_name'),
      reader.string('middle_name'),
    ].where((part) => part.isNotEmpty).join(' ');
    return InventoryTaskModel(
      id: reader.string('id'),
      inventoryId: reader.string('inventory_id'),
      location: reader.string('location'),
      status: reader.firstString(const ['common_status', 'status']),
      employeeName: employeeName,
      foundCount: reader.integer('found'),
      totalCount: reader.integer('total'),
    );
  }
}
