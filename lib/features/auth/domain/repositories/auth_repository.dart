import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/session/user.dart';

abstract interface class AuthRepository {
  /// Checks the credentials with the server and starts a session.
  Future<Result<User>> signIn({
    required String login,
    required String password,
  });

  /// Ends the session on this device. The backend has no logout endpoint.
  Future<void> signOut();
}
