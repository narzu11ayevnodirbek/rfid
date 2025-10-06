import 'package:rf_id_test/feature/home/domain/entity/get_list_entity/get_list_entity.dart';

class Inventory extends GetListEntity {
  const Inventory({
    required this.id,
    required this.name,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.countExcess,
    required this.createdBy,
    required this.closedBy,
    required this.closedAt,
  });

  final String id;
  final String name;
  final String status;
  final String userId;
  final String createdAt;
  final String updatedAt;
  final String type;
  final String countExcess;
  final String createdBy;
  final String closedBy;
  final String closedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        userId,
        createdAt,
        updatedAt,
        type,
        countExcess,
        createdBy,
        closedBy,
        closedAt,
      ];
}
