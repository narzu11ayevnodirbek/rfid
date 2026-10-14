import 'package:equatable/equatable.dart';

/// A place items can be moved to (building, room, shelf, ...).
class StorageLocation extends Equatable {
  const StorageLocation({
    required this.id,
    required this.name,
    required this.path,
  });

  final String id;
  final String name;

  /// Full path such as "Building A / Floor 2 / Room 5", if the server has it.
  final String path;

  String get displayName => path.isNotEmpty ? path : name;

  @override
  List<Object?> get props => [id, name, path];
}
