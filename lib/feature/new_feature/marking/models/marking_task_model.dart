class MarkingTaskModel {
  MarkingTaskModel({
    required this.id,
    required this.markingId,
    required this.executorId,
    required this.name,
    required this.status,
    required this.marked,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.executorName,
    required this.markingName,
    required this.items,
    required this.itemsCount,
    required this.markedCount,
  });

  factory MarkingTaskModel.fromJson(Map<String, dynamic> json) {
    return MarkingTaskModel(
      id: json['id'].toString(),
      markingId: json['marking_id'].toString(),
      executorId: json['executor_id'].toString(),
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      marked: int.parse(json['marked'] ?? '0'),
      total: int.parse(json['total'] ?? '0'),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      executorName: json['executor_name'] ?? '',
      markingName: json['marking_name'] ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      itemsCount: json['items_count'] ?? 0,
      markedCount: json['marked_count'] ?? 0,
    );
  }

  final String id;
  final String markingId;
  final String executorId;
  final String name;
  final String status;
  final int marked;
  final int total;
  final String createdAt;
  final String updatedAt;
  final String executorName;
  final String markingName;
  final List<Map<String, dynamic>> items;
  final int itemsCount;
  final int markedCount;
}
