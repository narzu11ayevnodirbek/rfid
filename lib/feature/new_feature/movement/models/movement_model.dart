class MovementModel {
  MovementModel({
    required this.id,
    required this.name,
    required this.destination,
    required this.description,
    required this.status,
    required this.creationDate,
  });

  factory MovementModel.fromJson(Map<String, dynamic> json) => MovementModel(
        id: json['id'],
        name: json['name'],
        destination: json['destination'],
        description: json['description'] ?? '',
        status: json['status'],
        creationDate: json['created_at'],
      );
  final String id;
  final String name;
  final String destination;
  final String? description;
  final String status;
  final String creationDate;
}
