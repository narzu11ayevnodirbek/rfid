import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/core/rfid/epc.dart';
import 'package:rfid/features/item_lookup/domain/entities/catalog_item.dart';

class CatalogItemModel extends CatalogItem {
  const CatalogItemModel({
    required super.id,
    required super.name,
    required super.code,
    required super.location,
    required super.responsible,
    required super.epc,
    required super.photoPath,
  });

  factory CatalogItemModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return CatalogItemModel(
      id: reader.string('id'),
      name: reader.string('name'),
      code: reader.firstString(const ['code', 'inventory_number', 'barcode']),
      location: reader.string('location'),
      responsible: reader.string('responsible'),
      epc: Epc.normalize(reader.string('rfid')),
      photoPath: reader.firstString(const ['photo_path', 'photo']),
    );
  }

  static List<CatalogItemModel> listFromBody(JsonMap body) =>
      JsonReader(body).mapList('data').map(CatalogItemModel.fromJson).toList();
}
