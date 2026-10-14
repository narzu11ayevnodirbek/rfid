import 'package:equatable/equatable.dart';

class Marking extends Equatable {
  const Marking({
    required this.id,
    required this.name,
    required this.type,
    required this.code,
    required this.status,
    required this.createdAt,
    required this.responsiblePerson,
  });

  final String id;
  final String name;
  final String type;
  final String code;
  final String status;
  final String createdAt;
  final String responsiblePerson;

  @override
  List<Object?> get props =>
      [id, name, type, code, status, createdAt, responsiblePerson];
}
