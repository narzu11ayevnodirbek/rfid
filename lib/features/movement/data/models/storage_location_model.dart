import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';

/// [StorageLocation] as returned by `api/locations.php`.
class StorageLocationModel extends StorageLocation {
  const StorageLocationModel({
    required super.id,
    required super.name,
    required super.path,
  });

  factory StorageLocationModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return StorageLocationModel(
      id: reader.string('id'),
      name: reader.string('name'),
      path: reader.string('path'),
    );
  }
}
