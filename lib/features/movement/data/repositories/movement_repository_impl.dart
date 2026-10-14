import 'dart:async';

import 'package:rfid/core/error/repository_guard.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/features/movement/data/datasources/movement_remote_data_source.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';
import 'package:rfid/features/movement/domain/repositories/movement_repository.dart';

class MovementRepositoryImpl implements MovementRepository {
  MovementRepositoryImpl(
    this._remote,
    this._session, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final MovementRemoteDataSource _remote;

  final SessionStorage _session;
  final DateTime Function() _now;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  List<MovementTask> _tasks = const [];

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<Result<List<MovementTask>>> getTasks() => guard(() async {
        return _tasks = await _remote.getTasks();
      });

  @override
  Future<Result<MovementTask>> getTask(String taskId) => guard(() async {
        MovementTask? find() {
          for (final task in _tasks) {
            if (task.id == taskId) return task;
          }
          return null;
        }

        final cached = find();
        if (cached != null) return cached;
        _tasks = await _remote.getTasks();
        return find() ?? (throw FormatException('No movement task $taskId'));
      });

  @override
  Future<Result<TransferResult>> moveForTask({
    required String movementId,
    required List<String> scannedEpcs,
  }) =>
      guard(() async {
        final result = await _remote.moveForTask(
          movementId: movementId,
          scannedEpcs: scannedEpcs,
        );
        _changes.add(null);
        return result;
      });

  @override
  Future<Result<List<StorageLocation>>> getLocations() =>
      guard(_remote.getLocations);

  @override
  Future<Result<TransferResult>> moveFreely({
    required String locationId,
    required List<String> scannedEpcs,
  }) =>
      guard(() async {
        final result = await _remote.moveFreely(
          locationId: locationId,
          scannedEpcs: scannedEpcs,
          userId: _session.user?.id ?? '',
          timestamp: _now(),
        );
        _changes.add(null);
        return result;
      });
}
