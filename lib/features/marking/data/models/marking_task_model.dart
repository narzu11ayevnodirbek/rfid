import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/marking/data/models/marking_item_model.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';

/// [MarkingTask] as returned by `api/get_marking_tasks_for_mobile.php`.
class MarkingTaskModel extends MarkingTask {
  const MarkingTaskModel({
    required super.id,
    required super.markingId,
    required super.name,
    required super.status,
    required super.executorName,
    required super.items,
  });

  factory MarkingTaskModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return MarkingTaskModel(
      id: reader.string('id'),
      markingId: reader.string('marking_id'),
      name: reader.firstString(const ['name', 'marking_name']),
      status: reader.string('status'),
      executorName: reader.string('executor_name'),
      items: reader.mapList('items').map(MarkingItemModel.fromJson).toList(),
    );
  }
}
