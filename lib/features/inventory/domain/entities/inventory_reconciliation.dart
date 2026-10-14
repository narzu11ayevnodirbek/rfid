import 'package:equatable/equatable.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';

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

  final List<ExpectedItem> found;

  final List<ExpectedItem> missing;

  final List<String> extraEpcs;

  int get expectedCount => found.length + missing.length;

  @override
  List<Object?> get props => [found, missing, extraEpcs];
}
