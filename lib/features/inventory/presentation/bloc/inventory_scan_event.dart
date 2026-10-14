part of 'inventory_scan_bloc.dart';

sealed class InventoryScanEvent {
  const InventoryScanEvent();
}

final class InventoryScanStarted extends InventoryScanEvent {
  const InventoryScanStarted();
}

final class InventoryScanPlanRequested extends InventoryScanEvent {
  const InventoryScanPlanRequested();
}

final class InventoryScanToggled extends InventoryScanEvent {
  const InventoryScanToggled();
}

final class InventoryScanListSelected extends InventoryScanEvent {
  const InventoryScanListSelected(this.list);

  final ReconciliationList list;
}

final class InventoryScanExtraTagRemoved extends InventoryScanEvent {
  const InventoryScanExtraTagRemoved(this.epc);

  final String epc;
}

final class InventoryScanFinishConfirmed extends InventoryScanEvent {
  const InventoryScanFinishConfirmed();
}

final class _ScanStateChanged extends InventoryScanEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}
