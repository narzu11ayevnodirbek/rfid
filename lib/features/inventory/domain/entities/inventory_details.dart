import 'package:equatable/equatable.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_task.dart';

class InventoryDetails extends Equatable {
  const InventoryDetails({required this.inventory, required this.tasks});

  final Inventory inventory;
  final List<InventoryTask> tasks;

  @override
  List<Object?> get props => [inventory, tasks];
}
