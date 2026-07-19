class InventoryTaskModel {
  InventoryTaskModel({
    required this.id,
    required this.inventoryId,
    required this.employeeId,
    required this.location,
    required this.status,
    required this.commonStatus,
    required this.found,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.lastName,
    required this.firstName,
    required this.middleName,
  });

  factory InventoryTaskModel.fromJson(Map<String, dynamic> json) => InventoryTaskModel(
        id: json['id'] ?? '',
        inventoryId: json['inventory_id'] ?? '',
        employeeId: json['employee_id'] ?? '',
        location: json['location'] ?? '',
        status: json['status'] ?? '',
        commonStatus: json['common_status'] ?? '',
        found: int.tryParse(json['found']?.toString() ?? '0') ?? 0,
        total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        lastName: json['last_name'] ?? '',
        firstName: json['first_name'] ?? '',
        middleName: json['middle_name'] ?? '',
      );

  final String id;
  final String inventoryId;
  final String employeeId;
  final String location;
  final String status;
  final String commonStatus;
  int found;
  int total;
  final String createdAt;
  final String updatedAt;
  final String lastName;
  final String firstName;
  final String middleName;
}
