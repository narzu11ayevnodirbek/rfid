import 'package:rf_id_test/feature/home/data/dto/get_list_model/get_list_model.dart';
import 'package:rf_id_test/feature/home/domain/entity/products/products.dart';

class ProductsDto extends GetListModel {
  const ProductsDto({
    this.id,
    this.name,
    this.inventoryId,
    this.barcode,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.location,
    this.responsible,
    this.status,
    this.statusFilter,
    this.hasRfid,
    this.photoPath,
    this.createdBy,
    this.markedBy,
    this.markedAt,
  });

  factory ProductsDto.fromJson(Map<String, dynamic> json) => ProductsDto(
        id: json['id'] as String?,
        name: json['name'] as String?,
        inventoryId: json['inventory_id'] as String?,
        barcode: json['barcode'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        price: json['price'] as String?,
        location: json['location'] as String?,
        responsible: json['responsible'] as String?,
        status: json['status'] as String?,
        statusFilter: json['status_filter'] as String?,
        hasRfid: json['has_rfid'] as String?,
        photoPath: json['photo_path'] as String?,
        createdBy: json['created_by'],
        markedBy: json['marked_by'],
        markedAt: json['marked_at'],
      );

  final String? id;
  final String? name;
  final String? inventoryId;
  final String? barcode;
  final String? createdAt;
  final String? updatedAt;
  final String? price;
  final String? location;
  final String? responsible;
  final String? status;
  final String? statusFilter;
  final String? hasRfid;
  final String? photoPath;
  final dynamic createdBy;
  final dynamic markedBy;
  final dynamic markedAt;

  @override
  Products toEntity() => Products(
        id: id ?? '',
        name: name ?? '',
        inventoryId: inventoryId ?? '',
        barcode: barcode ?? '',
        createdAt: createdAt ?? '',
        updatedAt: updatedAt ?? '',
        price: price ?? '',
        location: location ?? '',
        responsible: responsible ?? '',
        status: status ?? '',
        statusFilter: statusFilter ?? '',
        hasRfid: hasRfid ?? '',
        photoPath: photoPath ?? '',
        createdBy: createdBy,
        markedBy: markedBy,
        markedAt: markedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inventory_id': inventoryId,
        'barcode': barcode,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'price': price,
        'location': location,
        'responsible': responsible,
        'status': status,
        'status_filter': statusFilter,
        'has_rfid': hasRfid,
        'photo_path': photoPath,
        'created_by': createdBy,
        'marked_by': markedBy,
        'marked_at': markedAt,
      };
}
