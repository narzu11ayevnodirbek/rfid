part of 'item_lookup_bloc.dart';

class ItemLookupState extends Equatable {
  const ItemLookupState({
    this.catalog = const LoadInProgress<List<CatalogItem>>(),
    this.scan = const TagScanState(),
    this.foundItems = const [],
    this.unknownTagCount = 0,
  });

  final LoadState<List<CatalogItem>> catalog;
  final TagScanState scan;

  /// Items whose tag was read, most recent first.
  final List<CatalogItem> foundItems;

  /// Tags that belong to no item of the catalogue.
  final int unknownTagCount;

  ItemLookupState copyWith({
    LoadState<List<CatalogItem>>? catalog,
    TagScanState? scan,
    List<CatalogItem>? foundItems,
    int? unknownTagCount,
  }) {
    return ItemLookupState(
      catalog: catalog ?? this.catalog,
      scan: scan ?? this.scan,
      foundItems: foundItems ?? this.foundItems,
      unknownTagCount: unknownTagCount ?? this.unknownTagCount,
    );
  }

  @override
  List<Object?> get props => [catalog, scan, foundItems, unknownTagCount];
}
