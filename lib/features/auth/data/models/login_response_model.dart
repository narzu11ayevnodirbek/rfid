import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/auth/data/models/user_model.dart';

/// Body of a successful `POST api/auth.php?action=login`:
///
/// ```json
/// { "success": true, "token": "...", "user": { "id": "1", "login": "...", "username": "..." } }
/// ```
class LoginResponseModel {
  const LoginResponseModel({required this.token, required this.user});

  factory LoginResponseModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    final token = reader.stringOrNull('token');
    if (token == null) {
      throw const FormatException('Login response has no token');
    }
    final user = reader.mapOrNull('user');
    return LoginResponseModel(
      token: token,
      user: user == null
          ? const UserModel(id: '', login: '', username: '')
          : UserModel.fromJson(user),
    );
  }

  final String token;
  final UserModel user;
}
