part of 'movement_scan_bloc.dart';

sealed class MovementScanEvent {
  const MovementScanEvent();
}

/// Load (or reload after a failure) the task shown in the header.
final class MovementScanTaskRequested extends MovementScanEvent {
  const MovementScanTaskRequested();
}

final class MovementScanToggled extends MovementScanEvent {
  const MovementScanToggled();
}

final class MovementScanTagRemoved extends MovementScanEvent {
  const MovementScanTagRemoved(this.epc);

  final String epc;
}

final class MovementScanTagsCleared extends MovementScanEvent {
  const MovementScanTagsCleared();
}

final class MovementScanSubmitted extends MovementScanEvent {
  const MovementScanSubmitted();
}

final class _ScanStateChanged extends MovementScanEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}
