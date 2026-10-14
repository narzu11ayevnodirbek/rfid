import 'dart:async';

import 'package:rfid/core/error/repository_guard.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:rfid/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:rfid/features/inventory/data/models/inventory_model.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_details.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_draft.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';
import 'package:rfid/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl(this._remote, this._local);

  final InventoryRemoteDataSource _remote;
  final InventoryLocalDataSource _local;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  List<Inventory> _inventories = const [];

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<Result<List<Inventory>>> getActiveInventories() => guard(() async {
        _inventories = await _remote.getInventories();
        return _inventories.where((inventory) => !inventory.isClosed).toList();
      });

  @override
  Future<Result<InventoryDetails>> getDetails(String inventoryId) =>
      guard(() async {
        final (inventories, tasks) = await (
          _remote.getInventories(),
          _remote.getTasks(inventoryId),
        ).wait;
        _inventories = inventories;
        final inventory = inventories.firstWhere(
          (inventory) => inventory.id == inventoryId,
          orElse: () => InventoryModel.placeholder(inventoryId),
        );
        return InventoryDetails(inventory: inventory, tasks: tasks);
      });

  @override
  String? findInventoryName(String inventoryId) {
    for (final inventory in _inventories) {
      if (inventory.id == inventoryId) return inventory.name;
    }
    return null;
  }

  @override
  Future<Result<LoadedInventoryPlan>> getPlan(String inventoryId) async {
    final result = await guard(() => _remote.getPlan(inventoryId));
    switch (result) {
      case Success(:final value):
        await _local.savePlan(value);
        return Success(LoadedInventoryPlan(plan: value, isFromCache: false));
      case Failed(:final failure):
        final cached = _local.readPlan(inventoryId);
        if (cached == null) return Failed(failure);
        return Success(LoadedInventoryPlan(plan: cached, isFromCache: true));
    }
  }

  @override
  InventoryDraft? readDraft(String inventoryId) =>
      _local.readDraft(inventoryId);

  @override
  Future<void> saveDraft(String inventoryId, List<String> scannedEpcs) {
    return _local.saveDraft(
      inventoryId,
      InventoryDraft(scannedEpcs: scannedEpcs, savedAt: DateTime.now()),
    );
  }

  @override
  Future<Result<void>> finishInventory({
    required String inventoryId,
    required List<String> scannedEpcs,
    required Duration duration,
  }) =>
      guard(() async {
        await _remote.finishInventory(
          inventoryId: inventoryId,
          scannedEpcs: scannedEpcs,
          duration: duration,
        );
        await _local.deleteDraft(inventoryId);
        _changes.add(null);
      });
}
