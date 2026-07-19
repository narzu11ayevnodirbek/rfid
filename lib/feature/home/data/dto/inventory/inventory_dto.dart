import 'package:rfid/feature/home/data/dto/get_list_model/get_list_model.dart';
import 'package:rfid/feature/home/domain/entity/inventory/inventory.dart';

class InventoryDto extends GetListModel {
  InventoryDto({
    this.id,
    this.name,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.countExcess,
    this.createdBy,
    this.closedBy,
    this.closedAt,
  });

  factory InventoryDto.fromJson(Map<String, dynamic> json) => InventoryDto(
        id: json['id'] as String?,
        name: json['name'] as String?,
        status: json['status'] as String?,
        userId: json['user_id'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        type: json['type'] as String?,
        countExcess: json['count_excess'] as String?,
        createdBy: json['created_by'] as String?,
        closedBy: json['closed_by'] as String?,
        closedAt: json['closed_at'] as String?,
      );

  final String? id;
  final String? name;
  final String? status;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;
  final String? type;
  final String? countExcess;
  final String? createdBy;
  final String? closedBy;
  final String? closedAt;

  @override
  Inventory toEntity() => Inventory(
        id: id ?? '',
        name: name ?? '',
        status: status ?? '',
        userId: userId ?? '',
        createdAt: createdAt ?? '',
        updatedAt: updatedAt ?? '',
        type: type ?? '',
        countExcess: countExcess ?? '',
        createdBy: createdBy ?? '',
        closedBy: closedBy ?? '',
        closedAt: closedAt ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'user_id': userId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'type': type,
        'count_excess': countExcess,
        'created_by': createdBy,
        'closed_by': closedBy,
        'closed_at': closedAt,
      };
}
