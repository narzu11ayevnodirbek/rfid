import 'package:rfid/core/base/local_source.dart';
import 'package:rfid/feature/auth/data/remote/auth_remote_data_source.dart';
import 'package:rfid/feature/auth/domain/entity/user.dart';
import 'package:rfid/feature/auth/domain/repository/auth_params.dart';
import 'package:rfid/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required LocalSource localSource,
  })  : _remoteDataSource = remoteDataSource,
        _localSource = localSource;

  final AuthRemoteDataSource _remoteDataSource;
  final LocalSource _localSource;

  @override
  Future<User?> authenticate(AuthParams params) async {
    final response = await _remoteDataSource.authenticate(params);
    if (response.token != null) {
      await _localSource.setUserToken(response.token!);
    }
    return response.user?.toEntity();
  }
}
