import 'package:equatable/equatable.dart';

/// The signed-in employee.
class User extends Equatable {
  const User({required this.id, required this.login, required this.username});

  final String id;
  final String login;

  /// Display name.
  final String username;

  @override
  List<Object?> get props => [id, login, username];
}
