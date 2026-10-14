import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';
import 'package:rfid/features/marking/domain/repositories/marking_repository.dart';

/// Tasks of one marking. Reloads after a tag was bound.
class MarkingTaskListBloc extends ListBloc<MarkingTask> {
  MarkingTaskListBloc(this._repository, {required this.markingId})
      : super(invalidations: _repository.changes);

  final MarkingRepository _repository;
  final String markingId;

  @override
  Future<Result<List<MarkingTask>>> load() => _repository.getTasks(markingId);
}
