import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';
import 'package:rfid/features/marking/domain/repositories/marking_repository.dart';

class MarkingTaskItemsBloc extends LoadBloc<MarkingTask> {
  MarkingTaskItemsBloc(
    this._repository, {
    required this.markingId,
    required this.taskId,
  }) : super(invalidations: _repository.changes);

  final MarkingRepository _repository;
  final String markingId;
  final String taskId;

  @override
  Future<Result<MarkingTask>> load() =>
      _repository.getTask(markingId: markingId, taskId: taskId);
}
