import 'package:rfid/feature/auth/domain/entity/user.dart';
import 'package:rfid/feature/auth/domain/repository/auth_params.dart';

abstract interface class AuthRepository {
  Future<User?> authenticate(AuthParams params);
}
