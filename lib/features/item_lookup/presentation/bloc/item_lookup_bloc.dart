import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/core/rfid/tag_scan_state.dart';
import 'package:rfid/features/item_lookup/domain/entities/catalog_item.dart';
import 'package:rfid/features/item_lookup/domain/repositories/item_repository.dart';

part 'item_lookup_event.dart';
part 'item_lookup_state.dart';

/// "What is this?": read tags and show the catalogue items they belong to.
class ItemLookupBloc extends Bloc<ItemLookupEvent, ItemLookupState> {
  ItemLookupBloc({
    required ItemRepository repository,
    required RfidReader reader,
    TagScanSession? scanSession,
  })  : _repository = repository,
        _scan = scanSession ??
            TagScanSession(
              reader: reader,
              powerProfile: RfidPowerProfile.itemLookup,
            ),
        super(const ItemLookupState()) {
    on<ItemLookupCatalogRequested>(_onCatalogRequested);
    on<ItemLookupScanToggled>((event, emit) => _scan.toggle());
    on<ItemLookupCleared>((event, emit) => _scan.clear());
    on<_ScanStateChanged>(_onScanStateChanged);

    _scanSubscription =
        _scan.states.listen((scan) => add(_ScanStateChanged(scan)));
  }

  final ItemRepository _repository;
  final TagScanSession _scan;
  late final StreamSubscription<TagScanState> _scanSubscription;

  /// Catalogue indexed by EPC, built once per load.
  Map<String, CatalogItem> _itemsByEpc = const {};

  Future<void> _onCatalogRequested(
    ItemLookupCatalogRequested event,
    Emitter<ItemLookupState> emit,
  ) async {
    emit(state.copyWith(catalog: const LoadInProgress<List<CatalogItem>>()));
    switch (await _repository.getItems()) {
      case Success(:final value):
        _itemsByEpc = {
          for (final item in value)
            if (item.epc.isNotEmpty) item.epc: item,
        };
        emit(state.copyWith(catalog: LoadSuccess(value)));
        _match(state.scan, emit);
      case Failed(:final failure):
        emit(state.copyWith(catalog: LoadFailure(failure)));
    }
  }

  void _onScanStateChanged(
    _ScanStateChanged event,
    Emitter<ItemLookupState> emit,
  ) =>
      _match(event.scan, emit);

  void _match(TagScanState scan, Emitter<ItemLookupState> emit) {
    final found = <CatalogItem>[];
    var unknown = 0;
    for (final epc in scan.tags.reversed) {
      final item = _itemsByEpc[epc];
      if (item == null) {
        unknown++;
      } else {
        found.add(item);
      }
    }
    emit(
      state.copyWith(scan: scan, foundItems: found, unknownTagCount: unknown),
    );
  }

  @override
  Future<void> close() async {
    await _scanSubscription.cancel();
    await _scan.dispose();
    return super.close();
  }
}
