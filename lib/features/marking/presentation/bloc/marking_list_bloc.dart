import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/features/marking/domain/entities/marking.dart';
import 'package:rfid/features/marking/domain/repositories/marking_repository.dart';

/// All markings available to the user.
class MarkingListBloc extends ListBloc<Marking> {
  MarkingListBloc(this._repository);

  final MarkingRepository _repository;

  @override
  Future<Result<List<Marking>>> load() => _repository.getMarkings();
}
