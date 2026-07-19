import 'package:rfid/feature/new_feature/marking/services/marking_service.dart';

import 'models/marking_item.dart';

class MarkingRepository {
  MarkingRepository(this.apiService);

  final MarkingService apiService;

  Future<List<MarkingItem>> fetchMarkingItems(int markingId, int taskId) =>
      apiService.getMarkingItems(
        markingId: markingId,
        taskId: taskId.toString(),
      );
}
