part of 'free_transfer_bloc.dart';

sealed class FreeTransferEvent {
  const FreeTransferEvent();
}

/// Load (or reload after a failure) the list of locations.
final class FreeTransferLocationsRequested extends FreeTransferEvent {
  const FreeTransferLocationsRequested();
}

final class FreeTransferLocationSelected extends FreeTransferEvent {
  const FreeTransferLocationSelected(this.location);

  final StorageLocation location;
}

final class FreeTransferScanToggled extends FreeTransferEvent {
  const FreeTransferScanToggled();
}

final class FreeTransferTagRemoved extends FreeTransferEvent {
  const FreeTransferTagRemoved(this.epc);

  final String epc;
}

final class FreeTransferTagsCleared extends FreeTransferEvent {
  const FreeTransferTagsCleared();
}

final class FreeTransferSubmitted extends FreeTransferEvent {
  const FreeTransferSubmitted();
}

final class _ScanStateChanged extends FreeTransferEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}
