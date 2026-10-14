import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/session/user.dart';

abstract interface class AuthRepository {
  Future<Result<User>> signIn({
    required String login,
    required String password,
  });

  Future<void> signOut();
}
