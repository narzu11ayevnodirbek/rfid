import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/core/session/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.login,
    required super.username,
  });

  factory UserModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return UserModel(
      id: reader.string('id'),
      login: reader.string('login'),
      username: reader.string('username'),
    );
  }
}
