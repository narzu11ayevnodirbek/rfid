import 'package:rfid/core/network/json_reader.dart';
import 'package:rfid/features/marking/domain/entities/marking.dart';

/// [Marking] as returned by `api/markings.php`.
class MarkingModel extends Marking {
  const MarkingModel({
    required super.id,
    required super.name,
    required super.type,
    required super.code,
    required super.status,
    required super.createdAt,
    required super.responsiblePerson,
  });

  factory MarkingModel.fromJson(JsonMap json) {
    final reader = JsonReader(json);
    return MarkingModel(
      id: reader.string('id'),
      name: reader.string('name'),
      type: reader.string('type'),
      code: reader.string('code'),
      status: reader.string('status'),
      createdAt: reader.string('created_at'),
      responsiblePerson: reader.string('responsible_person'),
    );
  }
}
