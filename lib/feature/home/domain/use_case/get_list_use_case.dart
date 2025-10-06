import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rf_id_test/core/base/usecase.dart';
import 'package:rf_id_test/core/error/failure.dart';
import 'package:rf_id_test/feature/home/domain/entity/get_list_entity/get_list_entity.dart';
import 'package:rf_id_test/feature/home/domain/repository/home_repository.dart';

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
