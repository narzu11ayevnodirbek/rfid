import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_details.dart';
import 'package:rfid/features/inventory/domain/repositories/inventory_repository.dart';

/// One inventory with the progress of its tasks.
class InventoryDetailsBloc extends LoadBloc<InventoryDetails> {
  InventoryDetailsBloc(this._repository, {required this.inventoryId})
      : super(invalidations: _repository.changes);

  final InventoryRepository _repository;
  final String inventoryId;

  @override
  Future<Result<InventoryDetails>> load() =>
      _repository.getDetails(inventoryId);
}
