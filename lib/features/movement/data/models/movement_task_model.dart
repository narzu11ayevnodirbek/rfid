import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';

class MovementTaskModel extends MovementTask {
  const MovementTaskModel({
    required super.id,
    required super.movementId,
    required super.name,
    required super.status,
    required super.sourceLocation,
    required super.destination,
    required super.executorName,
    required super.createdAt,
    required super.movedCount,
    required super.totalCount,
  });

  factory MovementTaskModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return MovementTaskModel(
      id: reader.string('id'),
      movementId: reader.string('movement_id'),
      name: reader.firstString(const ['movement_name', 'name']),
      status: reader.string('status'),
      sourceLocation: reader.string('source_location'),
      destination: reader.string('destination'),
      executorName: reader.string('executor_name'),
      createdAt: reader.string('created_at'),
      movedCount:
          reader.integerOrNull('moved_count') ?? reader.integer('moved'),
      totalCount: reader.integerOrNull('items_count') ??
          reader.integerOrNull('total') ??
          reader.mapList('items').length,
    );
  }
}
