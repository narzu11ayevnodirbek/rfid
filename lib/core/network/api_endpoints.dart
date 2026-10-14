/// Every backend path the app calls, relative to `AppConfig.apiBaseUrl`.
///
/// See `docs/API.md` for request and response shapes.
abstract final class ApiEndpoints {
  // Auth
  static const String auth = 'api/auth.php';

  // Inventory
  static const String inventories = 'api/inventory.php';
  static const String inventoryTasks = 'api/inventory_tasks.php';
  static const String inventoryPlan = 'api/inventory_get_plan.php';
  static const String inventoryFinish = 'api/inventory_finish.php';

  // Item catalogue
  static const String items = 'api/items.php';

  // Marking
  static const String markings = 'api/markings.php';
  static const String markingTasks = 'api/get_marking_tasks_for_mobile.php';
  static const String markingItems = 'api/get_marking_items.php';
  static const String markingBindTag = 'api/process_marking_scan.php';

  // Movement
  static const String movementTasks = 'api/get_movement_tasks_for_mobile.php';
  static const String movementBatch = 'api/process_movement_batch.php';
  static const String locations = 'api/locations.php';
  static const String freeTransfer = 'api/transfer_free.php';
}
