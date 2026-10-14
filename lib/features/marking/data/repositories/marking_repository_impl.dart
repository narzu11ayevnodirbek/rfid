import 'dart:async';

import 'package:rfid/core/error/repository_guard.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/marking/data/datasources/marking_remote_data_source.dart';
import 'package:rfid/features/marking/domain/entities/marking.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';
import 'package:rfid/features/marking/domain/repositories/marking_repository.dart';

class MarkingRepositoryImpl implements MarkingRepository {
  MarkingRepositoryImpl(this._remote);

  final MarkingRemoteDataSource _remote;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  /// Last tasks loaded per marking.
  final Map<String, List<MarkingTask>> _tasksByMarking = {};

  /// Tags bound from this device (item id → EPC). Applied on top of server
  /// data in case the task list does not report bindings right away.
  final Map<String, String> _boundHere = {};

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<Result<List<Marking>>> getMarkings() => guard(_remote.getMarkings);

  @override
  Future<Result<List<MarkingTask>>> getTasks(String markingId) =>
      guard(() => _loadTasks(markingId));

  @override
  Future<Result<MarkingTask>> getTask({
    required String markingId,
    required String taskId,
  }) =>
      guard(() async {
        final tasks = await _loadTasks(markingId);
        return tasks.firstWhere(
          (task) => task.id == taskId,
          orElse: () => throw FormatException('No task $taskId'),
        );
      });

  @override
  Future<Result<MarkingItem>> getItem({
    required String markingId,
    required String taskId,
    required String itemId,
  }) =>
      guard(() async {
        final cached = _findCachedTask(markingId, taskId)?.findItem(itemId);
        if (cached != null) return cached;
        final tasks = await _loadTasks(markingId);
        for (final task in tasks) {
          if (task.id != taskId) continue;
          final item = task.findItem(itemId);
          if (item != null) return item;
        }
        throw FormatException('No item $itemId in task $taskId');
      });

  @override
  Future<Result<String>> getItemPhotoPath({
    required String markingId,
    required String itemId,
  }) =>
      guard(
        () => _remote.getItemPhotoPath(markingId: markingId, itemId: itemId),
      );

  @override
  Future<Result<void>> bindTag({
    required String markingId,
    required String taskId,
    required String itemId,
    required String epc,
  }) =>
      guard(() async {
        await _remote.bindTag(
          markingId: markingId,
          taskId: taskId,
          itemId: itemId,
          epc: epc,
        );
        _boundHere[itemId] = epc;
        _changes.add(null);
      });

  Future<List<MarkingTask>> _loadTasks(String markingId) async {
    final tasks = await _remote.getTasks(markingId);
    final merged = [for (final task in tasks) _withLocalBindings(task)];
    _tasksByMarking[markingId] = merged;
    return merged;
  }

  MarkingTask? _findCachedTask(String markingId, String taskId) {
    for (final task in _tasksByMarking[markingId] ?? const <MarkingTask>[]) {
      if (task.id == taskId) return task;
    }
    return null;
  }

  MarkingTask _withLocalBindings(MarkingTask task) {
    if (_boundHere.isEmpty) return task;
    return MarkingTask(
      id: task.id,
      markingId: task.markingId,
      name: task.name,
      status: task.status,
      executorName: task.executorName,
      items: [
        for (final item in task.items)
          switch (_boundHere[item.id]) {
            final epc? when !item.isBound => item.withBoundEpc(epc),
            _ => item,
          },
      ],
    );
  }
}
