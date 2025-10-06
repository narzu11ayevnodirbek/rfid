import 'package:rf_id_test/feature/auth/domain/entity/user.dart';

class AuthResponse {
  AuthResponse({
    required this.success,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        success: json['success'] as bool?,
        token: json['token'] as String?,
        user: json['user'] != null ? UserDto.fromJson(json['user']) : null,
      );

  final bool? success;
  final String? token;
  final UserDto? user;
}

class UserDto {
  UserDto({
    required this.id,
    required this.login,
    required this.username,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as String?,
        login: json['login'] as String?,
        username: json['username'] as String?,
      );

  final String? id;
  final String? login;
  final String? username;

  User toEntity() => User(
        id: id ?? '0',
        login: login ?? '',
        username: username ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'username': username,
      };
}
