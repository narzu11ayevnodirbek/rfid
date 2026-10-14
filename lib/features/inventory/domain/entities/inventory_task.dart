import 'package:equatable/equatable.dart';

class InventoryTask extends Equatable {
  const InventoryTask({
    required this.id,
    required this.inventoryId,
    required this.location,
    required this.status,
    required this.employeeName,
    required this.foundCount,
    required this.totalCount,
  });

  final String id;
  final String inventoryId;
  final String location;
  final String status;
  final String employeeName;
  final int foundCount;
  final int totalCount;

  @override
  List<Object?> get props =>
      [id, inventoryId, location, status, employeeName, foundCount, totalCount];
}
