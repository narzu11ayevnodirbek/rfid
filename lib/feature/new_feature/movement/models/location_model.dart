/// Локация для выбора «куда перемещаем» (GET /api/locations).
class LocationModel {
  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.path,
    this.description,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
        name: (json['name'] ?? '').toString(),
        type: (json['type'] ?? '').toString(),
        parentId: int.tryParse(json['parent_id']?.toString() ?? ''),
        path: json['path']?.toString(),
        description: json['description']?.toString(),
      );

  final int id;
  final String name;
  final String type;
  final int? parentId;
  final String? path;
  final String? description;

  String get displayName => path ?? name;
}
