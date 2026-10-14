part of 'item_lookup_bloc.dart';

sealed class ItemLookupEvent {
  const ItemLookupEvent();
}

final class ItemLookupCatalogRequested extends ItemLookupEvent {
  const ItemLookupCatalogRequested();
}

final class ItemLookupScanToggled extends ItemLookupEvent {
  const ItemLookupScanToggled();
}

final class ItemLookupCleared extends ItemLookupEvent {
  const ItemLookupCleared();
}

final class _ScanStateChanged extends ItemLookupEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}
