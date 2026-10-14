import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';

/// [Inventory] as returned by `api/inventory.php`.
class InventoryModel extends Inventory {
  const InventoryModel({
    required super.id,
    required super.name,
    required super.type,
    required super.responsibleName,
    required super.createdAt,
    required super.statusCode,
    required super.statusLabel,
    required super.foundCount,
    required super.missingCount,
    required super.totalCount,
  });

  /// Stands in for an inventory that is no longer in the user's list.
  const InventoryModel.placeholder(String id)
      : this(
          id: id,
          name: id,
          type: '',
          responsibleName: '',
          createdAt: '',
          statusCode: '',
          statusLabel: '',
          foundCount: 0,
          missingCount: 0,
          totalCount: 0,
        );

  factory InventoryModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return InventoryModel(
      id: reader.string('id'),
      name: reader.string('name'),
      type: reader.string('type'),
      responsibleName: reader.string('user_name'),
      createdAt: reader.string('created_at'),
      statusCode: reader.string('status_code'),
      statusLabel: reader.string('status_label'),
      foundCount: reader.integer('found'),
      missingCount: reader.integer('not_found'),
      totalCount: reader.integer('total'),
    );
  }
}
