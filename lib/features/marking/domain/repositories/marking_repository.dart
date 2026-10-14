import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/marking/domain/entities/marking.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';

abstract interface class MarkingRepository {
  Stream<void> get changes;

  Future<Result<List<Marking>>> getMarkings();

  Future<Result<List<MarkingTask>>> getTasks(String markingId);

  Future<Result<MarkingTask>> getTask({
    required String markingId,
    required String taskId,
  });

  Future<Result<MarkingItem>> getItem({
    required String markingId,
    required String taskId,
    required String itemId,
  });

  Future<Result<String>> getItemPhotoPath({
    required String markingId,
    required String itemId,
  });

  Future<Result<void>> bindTag({
    required String markingId,
    required String taskId,
    required String itemId,
    required String epc,
  });
}
