import 'package:rfid/feature/new_feature/inventory/models/inventory_item.dart';
import 'package:rfid/feature/new_feature/inventory/services/inventory_service.dart';

class InventoryRepository {
  InventoryRepository(this.apiService);

  final InventoryService apiService;

  Future<List<InventoryItem>> fetchInventoryItems(int inventoryId) => apiService.getInventoryItems(
        inventoryId: inventoryId,
      );
}
