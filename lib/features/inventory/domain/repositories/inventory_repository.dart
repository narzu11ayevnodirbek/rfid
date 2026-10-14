import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_details.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_draft.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';

abstract interface class InventoryRepository {
  /// Fires after an inventory was finished, so lists can reload.
  Stream<void> get changes;

  /// Inventories that are not closed yet.
  Future<Result<List<Inventory>>> getActiveInventories();

  /// One inventory with its tasks.
  Future<Result<InventoryDetails>> getDetails(String inventoryId);

  /// Name of the inventory as last loaded, or `null` if not loaded yet.
  String? findInventoryName(String inventoryId);

  /// The expected items; falls back to the copy saved on the device when the
  /// server is unreachable.
  Future<Result<LoadedInventoryPlan>> getPlan(String inventoryId);

  InventoryDraft? readDraft(String inventoryId);

  Future<void> saveDraft(String inventoryId, List<String> scannedEpcs);

  /// Sends the scanned tags. On success the draft is deleted.
  Future<Result<void>> finishInventory({
    required String inventoryId,
    required List<String> scannedEpcs,
    required Duration duration,
  });
}
