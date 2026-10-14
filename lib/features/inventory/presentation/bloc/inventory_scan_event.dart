part of 'inventory_scan_bloc.dart';

sealed class InventoryScanEvent {
  const InventoryScanEvent();
}

/// The screen opened: restore the draft and load the plan.
final class InventoryScanStarted extends InventoryScanEvent {
  const InventoryScanStarted();
}

/// Try to load the plan again (after it failed).
final class InventoryScanPlanRequested extends InventoryScanEvent {
  const InventoryScanPlanRequested();
}

final class InventoryScanToggled extends InventoryScanEvent {
  const InventoryScanToggled();
}

/// Show the found, missing or extra items.
final class InventoryScanListSelected extends InventoryScanEvent {
  const InventoryScanListSelected(this.list);

  final ReconciliationList list;
}

/// Drop a tag that does not belong here (read from a neighbouring room).
final class InventoryScanExtraTagRemoved extends InventoryScanEvent {
  const InventoryScanExtraTagRemoved(this.epc);

  final String epc;
}

/// The user confirmed: send the result to the server.
final class InventoryScanFinishConfirmed extends InventoryScanEvent {
  const InventoryScanFinishConfirmed();
}

final class _ScanStateChanged extends InventoryScanEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}
