import 'package:equatable/equatable.dart';

class StorageLocation extends Equatable {
  const StorageLocation({
    required this.id,
    required this.name,
    required this.path,
  });

  final String id;
  final String name;

  final String path;

  String get displayName => path.isNotEmpty ? path : name;

  @override
  List<Object?> get props => [id, name, path];
}
