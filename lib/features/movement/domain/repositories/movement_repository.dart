import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';

abstract interface class MovementRepository {
  /// Fires after items were moved, so lists can reload.
  Stream<void> get changes;

  Future<Result<List<MovementTask>>> getTasks();

  /// One task, from the last loaded list or fetched again.
  Future<Result<MovementTask>> getTask(String taskId);

  /// Moves the scanned items as part of a movement task.
  Future<Result<TransferResult>> moveForTask({
    required String movementId,
    required List<String> scannedEpcs,
  });

  Future<Result<List<StorageLocation>>> getLocations();

  /// Moves the scanned items to [locationId] without a task.
  Future<Result<TransferResult>> moveFreely({
    required String locationId,
    required List<String> scannedEpcs,
  });
}
