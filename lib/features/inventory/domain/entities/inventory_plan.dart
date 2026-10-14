import 'package:equatable/equatable.dart';

/// An item the server expects to find during the inventory.
class ExpectedItem extends Equatable {
  const ExpectedItem({required this.epc, required this.name});

  /// Normalized EPC of the item's tag (empty if the item has no tag).
  final String epc;
  final String name;

  @override
  List<Object?> get props => [epc, name];
}

/// Everything that should be found in the inventory.
class InventoryPlan extends Equatable {
  const InventoryPlan({
    required this.inventoryId,
    required this.locationName,
    required this.expectedItems,
  });

  /// A plan without items: every scanned tag counts as extra.
  const InventoryPlan.empty(this.inventoryId)
      : locationName = '',
        expectedItems = const [];

  final String inventoryId;
  final String locationName;
  final List<ExpectedItem> expectedItems;

  @override
  List<Object?> get props => [inventoryId, locationName, expectedItems];
}

/// A plan and where it came from.
class LoadedInventoryPlan extends Equatable {
  const LoadedInventoryPlan({required this.plan, required this.isFromCache});

  final InventoryPlan plan;

  /// The server was unreachable and the copy saved last time is used.
  final bool isFromCache;

  @override
  List<Object?> get props => [plan, isFromCache];
}
