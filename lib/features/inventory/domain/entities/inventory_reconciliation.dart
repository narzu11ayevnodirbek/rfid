import 'package:equatable/equatable.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';

/// The plan compared with what was scanned: the result of an inventory.
///
/// Pure calculation, no I/O, so it is trivial to test and can be recomputed
/// after every tag.
class InventoryReconciliation extends Equatable {
  const InventoryReconciliation({
    this.found = const [],
    this.missing = const [],
    this.extraEpcs = const [],
  });

  factory InventoryReconciliation.compute({
    required InventoryPlan plan,
    required List<String> scannedEpcs,
  }) {
    final scanned = scannedEpcs.toSet();
    final expectedEpcs = {for (final item in plan.expectedItems) item.epc};
    return InventoryReconciliation(
      found: [
        for (final item in plan.expectedItems)
          if (scanned.contains(item.epc)) item,
      ],
      missing: [
        for (final item in plan.expectedItems)
          if (!scanned.contains(item.epc)) item,
      ],
      extraEpcs: [
        for (final epc in scannedEpcs)
          if (!expectedEpcs.contains(epc)) epc,
      ],
    );
  }

  /// Expected and scanned.
  final List<ExpectedItem> found;

  /// Expected but not scanned (yet).
  final List<ExpectedItem> missing;

  /// Scanned but not expected here, in reading order.
  final List<String> extraEpcs;

  int get expectedCount => found.length + missing.length;

  @override
  List<Object?> get props => [found, missing, extraEpcs];
}
