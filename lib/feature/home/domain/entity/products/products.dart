import 'package:rfid/feature/home/domain/entity/get_list_entity/get_list_entity.dart';

class Products extends GetListEntity {
  const Products({
    required this.id,
    required this.name,
    required this.inventoryId,
    required this.barcode,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
    required this.location,
    required this.responsible,
    required this.status,
    required this.statusFilter,
    required this.hasRfid,
    required this.photoPath,
    required this.createdBy,
    required this.markedBy,
    required this.markedAt,
  });

  final String id;
  final String name;
  final String inventoryId;
  final String barcode;
  final String createdAt;
  final String updatedAt;
  final String price;
  final String location;
  final String responsible;
  final String status;
  final String statusFilter;
  final String hasRfid;
  final String photoPath;
  final dynamic createdBy;
  final dynamic markedBy;
  final dynamic markedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        inventoryId,
        barcode,
        createdAt,
        updatedAt,
        price,
        location,
        responsible,
        status,
        statusFilter,
        hasRfid,
        photoPath,
        createdBy,
        markedBy,
        markedAt,
      ];
}
