import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/domain/repositories/inventory_repository.dart';

/// Active inventories of the user. Reloads after an inventory is finished.
class InventoryListBloc extends ListBloc<Inventory> {
  InventoryListBloc(this._repository)
      : super(invalidations: _repository.changes);

  final InventoryRepository _repository;

  @override
  Future<Result<List<Inventory>>> load() => _repository.getActiveInventories();
}
