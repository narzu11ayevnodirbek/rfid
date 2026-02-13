class MarkingModel {
  MarkingModel({
    required this.id,
    required this.name,
    required this.type,
    required this.code,
    required this.status,
    required this.description,
    required this.responsibleId,
    required this.createdAt,
    required this.updatedAt,
    required this.closedAt,
    required this.responsiblePerson,
  });

  factory MarkingModel.fromJson(Map<String, dynamic> json) => MarkingModel(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        code: json['code'] ?? '',
        status: json['status'] ?? '',
        description: json['description'] ?? '',
        responsibleId: json['responsible_id'] ?? '',
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        closedAt: json['closed_at'] ?? '',
        responsiblePerson: json['responsible_person'] ?? '',
      );
  final String id;
  final String name;
  final String type;
  final String code;
  final String status;
  final String description;
  final String responsibleId;
  final String createdAt;
  final String updatedAt;
  final String closedAt;
  final String responsiblePerson;
}
