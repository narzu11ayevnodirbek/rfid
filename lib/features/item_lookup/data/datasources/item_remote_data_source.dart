import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/item_lookup/data/models/catalog_item_model.dart';

/// Catalogue requests.
class ItemRemoteDataSource {
  const ItemRemoteDataSource(this._api);

  final ApiClient _api;

  /// `GET api/items.php`
  Future<List<CatalogItemModel>> getItems() async {
    final json = await _api.get(ApiEndpoints.items);
    return JsonReader(json)
        .mapList('data')
        .map(CatalogItemModel.fromJson)
        .toList();
  }
}
