import 'package:dartz/dartz.dart';
import 'package:rfid/domain/failures/failure.dart';
import 'package:rfid/feature/home/domain/entity/get_list_entity/get_list_entity.dart';
import 'package:rfid/feature/home/domain/use_case/get_list_use_case.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, List<GetListEntity>>> getList(GetListParams params);
}
