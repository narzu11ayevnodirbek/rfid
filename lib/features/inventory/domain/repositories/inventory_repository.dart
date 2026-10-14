import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_details.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_draft.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';

abstract interface class InventoryRepository {
  Stream<void> get changes;

  Future<Result<List<Inventory>>> getActiveInventories();

  Future<Result<InventoryDetails>> getDetails(String inventoryId);

  String? findInventoryName(String inventoryId);

  Future<Result<LoadedInventoryPlan>> getPlan(String inventoryId);

  InventoryDraft? readDraft(String inventoryId);

  Future<void> saveDraft(String inventoryId, List<String> scannedEpcs);

  Future<Result<void>> finishInventory({
    required String inventoryId,
    required List<String> scannedEpcs,
    required Duration duration,
  });
}
