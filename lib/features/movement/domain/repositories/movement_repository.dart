import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';

abstract interface class MovementRepository {
  Stream<void> get changes;

  Future<Result<List<MovementTask>>> getTasks();

  Future<Result<MovementTask>> getTask(String taskId);

  Future<Result<TransferResult>> moveForTask({
    required String movementId,
    required List<String> scannedEpcs,
  });

  Future<Result<List<StorageLocation>>> getLocations();

  Future<Result<TransferResult>> moveFreely({
    required String locationId,
    required List<String> scannedEpcs,
  });
}
