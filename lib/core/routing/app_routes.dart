abstract final class AppRoutes {
  static const String login = '/login';

  static const String inventory = '/inventory';
  static const String marking = '/marking';
  static const String movement = '/movement';
  static const String settings = '/settings';

  static const String itemLookup = '/item-lookup';
  static const String readerDiagnostics = '/settings/reader';
  static const String freeTransfer = '/movement/free-transfer';

  static String inventoryDetails(String inventoryId) =>
      '$inventory/${_id(inventoryId)}';

  static String inventoryScan(String inventoryId) =>
      '$inventory/${_id(inventoryId)}/scan';

  static String markingTasks(String markingId) =>
      '$marking/${_id(markingId)}/tasks';

  static String markingTaskItems(String markingId, String taskId) =>
      '${markingTasks(markingId)}/${_id(taskId)}';

  static String markingTagBind(
    String markingId,
    String taskId,
    String itemId,
  ) =>
      '${markingTaskItems(markingId, taskId)}/items/${_id(itemId)}';

  static String movementScan(String taskId) =>
      '$movement/tasks/${_id(taskId)}/scan';

  static String _id(String id) => Uri.encodeComponent(id);
}
