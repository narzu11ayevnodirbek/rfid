import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/marking/domain/entities/marking.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';

abstract interface class MarkingRepository {
  /// Fires after a tag was bound, so task lists can reload.
  Stream<void> get changes;

  Future<Result<List<Marking>>> getMarkings();

  Future<Result<List<MarkingTask>>> getTasks(String markingId);

  /// One task, from the last loaded list or fetched again.
  Future<Result<MarkingTask>> getTask({
    required String markingId,
    required String taskId,
  });

  /// One item of a task.
  Future<Result<MarkingItem>> getItem({
    required String markingId,
    required String taskId,
    required String itemId,
  });

  /// Photo of an item (empty when there is none).
  Future<Result<String>> getItemPhotoPath({
    required String markingId,
    required String itemId,
  });

  /// Links the tag [epc] to the item on the server.
  Future<Result<void>> bindTag({
    required String markingId,
    required String taskId,
    required String itemId,
    required String epc,
  });
}
