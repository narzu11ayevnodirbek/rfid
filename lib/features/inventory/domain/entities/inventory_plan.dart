import 'package:equatable/equatable.dart';

class ExpectedItem extends Equatable {
  const ExpectedItem({required this.epc, required this.name});

  final String epc;
  final String name;

  @override
  List<Object?> get props => [epc, name];
}

class InventoryPlan extends Equatable {
  const InventoryPlan({
    required this.inventoryId,
    required this.locationName,
    required this.expectedItems,
  });

  const InventoryPlan.empty(this.inventoryId)
      : locationName = '',
        expectedItems = const [];

  final String inventoryId;
  final String locationName;
  final List<ExpectedItem> expectedItems;

  @override
  List<Object?> get props => [inventoryId, locationName, expectedItems];
}

class LoadedInventoryPlan extends Equatable {
  const LoadedInventoryPlan({required this.plan, required this.isFromCache});

  final InventoryPlan plan;

  final bool isFromCache;

  @override
  List<Object?> get props => [plan, isFromCache];
}
