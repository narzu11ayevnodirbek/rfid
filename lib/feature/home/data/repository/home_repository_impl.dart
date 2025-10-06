import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:rf_id_test/core/base/base_functions.dart';
import 'package:rf_id_test/core/base/local_source.dart';
import 'package:rf_id_test/core/error/exceptions.dart';
import 'package:rf_id_test/core/error/failure.dart';
import 'package:rf_id_test/feature/home/data/remote/home_remote_data_source.dart';
import 'package:rf_id_test/feature/home/domain/entity/get_list_entity/get_list_entity.dart';
import 'package:rf_id_test/feature/home/domain/repository/home_repository.dart';
import 'package:rf_id_test/feature/home/domain/use_case/get_list_use_case.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required LocalSource localSource,
  })  : _remoteDataSource = remoteDataSource,
        _localSource = localSource;

  final HomeRemoteDataSource _remoteDataSource;
  final LocalSource _localSource;

  @override
  Future<Either<Failure, List<GetListEntity>>> getList(GetListParams params) async {
    try {
      final response = await _remoteDataSource.getList(params);
      return Right(response.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e is ServerException
          ? ServerFailure(message: e.message ?? 'unknown', response: e.response)
          : ServerFailure(message: e.toString()));
    }
  }
}
