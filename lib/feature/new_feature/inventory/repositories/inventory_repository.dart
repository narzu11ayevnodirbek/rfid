import '../models/inventory_item.dart';
import '../services/inventory_service.dart';

class InventoryRepository {
  InventoryRepository(this.apiService);

  final InventoryService apiService;

  Future<List<InventoryItem>> fetchInventoryItems(int inventoryId) =>
      apiService.getInventoryItems(
        inventoryId: inventoryId,
      );
}
