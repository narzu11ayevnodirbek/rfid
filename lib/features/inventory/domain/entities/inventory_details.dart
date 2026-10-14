import 'package:equatable/equatable.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_task.dart';

/// What the inventory details screen shows: the inventory and its tasks.
class InventoryDetails extends Equatable {
  const InventoryDetails({required this.inventory, required this.tasks});

  final Inventory inventory;
  final List<InventoryTask> tasks;

  @override
  List<Object?> get props => [inventory, tasks];
}
