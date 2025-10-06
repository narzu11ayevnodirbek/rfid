import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.login,
    required this.username,
  });

  final String id;
  final String login;
  final String username;

  @override
  List<Object?> get props => [id, login, username];
}
