import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/item_lookup/domain/entities/catalog_item.dart';

abstract interface class ItemRepository {
  /// The whole catalogue. The backend has no "find by EPC" endpoint, so the
  /// app downloads the list once and matches tags locally.
  Future<Result<List<CatalogItem>>> getItems();
}
