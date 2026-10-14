import 'package:rfid/core/error/repository_guard.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/item_lookup/data/datasources/item_remote_data_source.dart';
import 'package:rfid/features/item_lookup/domain/entities/catalog_item.dart';
import 'package:rfid/features/item_lookup/domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  const ItemRepositoryImpl(this._remote);

  final ItemRemoteDataSource _remote;

  @override
  Future<Result<List<CatalogItem>>> getItems() => guard(_remote.getItems);
}
