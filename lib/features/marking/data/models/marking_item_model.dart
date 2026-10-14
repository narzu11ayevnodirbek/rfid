import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/core/rfid/epc.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';

class MarkingItemModel extends MarkingItem {
  const MarkingItemModel({
    required super.id,
    required super.name,
    required super.inventoryNumber,
    required super.status,
    required super.photoPath,
    required super.boundEpc,
  });

  factory MarkingItemModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return MarkingItemModel(
      id: reader.firstString(const ['item_id', 'id']),
      name: reader.string('name'),
      inventoryNumber:
          reader.firstString(const ['inventory_number', 'barcode']),
      status: reader.string('status'),
      photoPath: reader.firstString(const ['photo', 'photo_path']),
      boundEpc: Epc.normalize(reader.string('rfid')),
    );
  }
}
