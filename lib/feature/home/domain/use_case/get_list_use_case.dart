import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rfid/core/base/usecase.dart';
import 'package:rfid/domain/failures/failure.dart';
import 'package:rfid/feature/home/domain/entity/get_list_entity/get_list_entity.dart';
import 'package:rfid/feature/home/domain/repository/home_repository.dart';

class GetListUseCase implements UseCase<List<GetListEntity>, GetListParams> {
  GetListUseCase({required HomeRepository repository}) : _repository = repository;

  final HomeRepository _repository;

  @override
  Future<Either<Failure, List<GetListEntity>>> call(GetListParams params) =>
      _repository.getList(params);
}

class GetListParams extends Equatable {
  const GetListParams({
    required this.destination,
    this.queryParameters,
  });

  final String destination;
  final Map<String, dynamic>? queryParameters;

  @override
  List<Object?> get props => [destination, queryParameters];
}
