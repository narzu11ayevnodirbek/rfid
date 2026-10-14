import 'package:rfid/core/error/repository_guard.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/core/session/user.dart';
import 'package:rfid/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rfid/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._session);

  final AuthRemoteDataSource _remote;
  final SessionStorage _session;

  @override
  Future<Result<User>> signIn({
    required String login,
    required String password,
  }) {
    return guard(() async {
      final response = await _remote.login(login: login, password: password);
      await _session.start(token: response.token, user: response.user);
      return response.user;
    });
  }

  @override
  Future<void> signOut() => _session.end();
}
