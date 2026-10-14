import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/network/api_endpoints.dart';
import 'package:rfid/features/item_lookup/data/models/catalog_item_model.dart';

class ItemRemoteDataSource {
  const ItemRemoteDataSource(this._api);

  final ApiClient _api;

  // The catalogue is several megabytes: decoded and parsed off the UI thread.
  Future<List<CatalogItemModel>> getItems() =>
      _api.getInBackground(ApiEndpoints.items, CatalogItemModel.listFromBody);
}
