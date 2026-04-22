import 'package:dartz/dartz.dart';
import 'package:rf_id_test/core/error/failure.dart';

// ignore: avoid_types_as_parameter_names
abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
