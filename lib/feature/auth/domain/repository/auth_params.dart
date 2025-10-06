import 'package:equatable/equatable.dart';

class AuthParams extends Equatable {
  const AuthParams({
    required this.login,
    this.userName = '',
    required this.password,
    required this.action,
  });

  final String login;
  final String userName;
  final String password;
  final String action;

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
        if (userName.isNotEmpty) 'username': userName,
      };

  @override
  List<Object?> get props => [login, userName, password];
}
