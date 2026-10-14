import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/rfid/fake_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/features/item_lookup/data/models/catalog_item_model.dart';
import 'package:rfid/features/item_lookup/domain/entities/catalog_item.dart';
import 'package:rfid/features/item_lookup/domain/repositories/item_repository.dart';
import 'package:rfid/features/item_lookup/presentation/bloc/item_lookup_bloc.dart';

class _MockRepository extends Mock implements ItemRepository {}

void main() {
  final table = CatalogItemModel.fromJson(const {
    'id': 1,
    'name': 'Стол',
    'code': 'INV-1',
    'location': 'Кабинет 5',
    'responsible': 'Иванов',
    'rfid': ' e2001 ',
    'photo_path': 'uploads/1.jpg',
  });
  final chair = CatalogItemModel.fromJson(const {
    'id': '2',
    'name': 'Стул',
    'rfid': 'E2002',
  });

  test('CatalogItemModel normalizes the EPC', () {
    expect(table.id, '1');
    expect(table.epc, 'E2001');
    expect(table.photoPath, 'uploads/1.jpg');
  });

  group('ItemLookupBloc', () {
    late _MockRepository repository;
    late FakeRfidReader reader;

    ItemLookupBloc build() => ItemLookupBloc(
          repository: repository,
          reader: reader,
          scanSession: TagScanSession(
            reader: reader,
            powerProfile: RfidPowerProfile.itemLookup,
            onNewTag: () {},
          ),
        );

    setUp(() {
      repository = _MockRepository();
      reader = FakeRfidReader();
    });

    test('shows the items of the tags read, newest first', () async {
      when(() => repository.getItems())
          .thenAnswer((_) async => Success<List<CatalogItem>>([table, chair]));
      final bloc = build()..add(const ItemLookupCatalogRequested());
      await pumpEventQueue();

      bloc.add(const ItemLookupScanToggled());
      await pumpEventQueue();
      reader
        ..simulateTag('E2001')
        ..simulateTag('E9999')
        ..simulateTag('e2002');
      await pumpEventQueue();

      expect(bloc.state.foundItems, [chair, table]);
      expect(bloc.state.unknownTagCount, 1);

      bloc.add(const ItemLookupCleared());
      await pumpEventQueue();
      expect(bloc.state.foundItems, isEmpty);
      await bloc.close();
    });

    test('reports a catalogue that could not be loaded', () async {
      when(() => repository.getItems()).thenAnswer(
        (_) async => const Failed<List<CatalogItem>>(NetworkFailure()),
      );

      final bloc = build()..add(const ItemLookupCatalogRequested());
      await pumpEventQueue();

      expect(
        bloc.state.catalog,
        const LoadFailure<List<CatalogItem>>(NetworkFailure()),
      );
      await bloc.close();
    });
  });
}
