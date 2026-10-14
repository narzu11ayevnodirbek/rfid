import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/item_lookup/domain/entities/catalog_item.dart';

abstract interface class ItemRepository {
  Future<Result<List<CatalogItem>>> getItems();
}
