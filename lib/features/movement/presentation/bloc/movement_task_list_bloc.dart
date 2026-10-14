import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';
import 'package:rfid/features/movement/domain/repositories/movement_repository.dart';

class MovementTaskListBloc extends ListBloc<MovementTask> {
  MovementTaskListBloc(this._repository)
      : super(invalidations: _repository.changes);

  final MovementRepository _repository;

  @override
  Future<Result<List<MovementTask>>> load() => _repository.getTasks();
}
