import 'package:dartz/dartz.dart';
import 'package:rf_id_test/core/error/failure.dart';
import 'package:rf_id_test/feature/home/domain/entity/get_list_entity/get_list_entity.dart';
import 'package:rf_id_test/feature/home/domain/use_case/get_list_use_case.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, List<GetListEntity>>> getList(GetListParams params);
}
