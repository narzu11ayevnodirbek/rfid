class MovementTaskModel {
  MovementTaskModel({
    required this.id,
    required this.movementId,
    required this.executorId,
    required this.name,
    required this.status,
    required this.moved,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.executorName,
    required this.movementName,
    required this.destination,
    required this.items,
    required this.itemsCount,
    required this.movedCount,
  });

  factory MovementTaskModel.fromJson(Map<String, dynamic> json) {
    return MovementTaskModel(
      id: json['id'].toString(),
      movementId: json['movement_id'].toString(),
      executorId: json['executor_id'].toString(),
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      moved: int.parse(json['moved'] ?? '0'),
      total: int.parse(json['total'] ?? '0'),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      executorName: json['executor_name'] ?? '',
      movementName: json['movement_name'] ?? '',
      destination: json['destination'] ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      itemsCount: json['items_count'] ?? 0,
      movedCount: json['moved_count'] ?? 0,
    );
  }

  final String id;
  final String movementId;
  final String executorId;
  final String name;
  final String status;
  final int moved;
  final int total;
  final String createdAt;
  final String updatedAt;
  final String executorName;
  final String movementName;
  final String destination;
  final List<Map<String, dynamic>> items;
  final int itemsCount;
  final int movedCount;
}
