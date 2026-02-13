class InventoryModel {
  InventoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.countExcess,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.closedAt,
    required this.userName,
    required this.found,
    required this.notFound,
    required this.total,
    required this.statusCode,
    required this.statusLabel,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        countExcess: json['count_excess'] ?? '',
        userId: json['user_id'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        closedAt: json['closed_at'] ?? '',
        userName: json['user_name'] ?? '',
        found: int.tryParse(json['found']?.toString() ?? '0') ?? 0,
        notFound: int.tryParse(json['not_found']?.toString() ?? '0') ?? 0,
        total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
        statusCode: json['status_code'] ?? '',
        statusLabel: json['status_label'] ?? '',
      );

  final String id;
  final String name;
  final String type;
  final String countExcess;
  final String userId;
  final String createdAt;
  final String updatedAt;
  final String closedAt;
  final String userName;
  int found;
  int notFound;
  int total;
  final String statusCode;
  final String statusLabel;
}
