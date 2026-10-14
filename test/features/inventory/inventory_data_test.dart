import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/storage/in_memory_key_value_store.dart';
import 'package:rfid/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:rfid/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:rfid/features/inventory/data/models/inventory_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_plan_model.dart';
import 'package:rfid/features/inventory/data/models/inventory_task_model.dart';
import 'package:rfid/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_reconciliation.dart';

class _MockRemote extends Mock implements InventoryRemoteDataSource {}

InventoryModel _inventory(String id, {String status = 'active'}) =>
    InventoryModel.fromJson({
      'id': id,
      'name': 'INV-$id',
      'status_code': status,
    });

void main() {
  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(Duration.zero);
  });

  group('models', () {
    test('InventoryModel accepts counters as text or numbers', () {
      final model = InventoryModel.fromJson(const {
        'id': 12,
        'name': '0042',
        'type': 'Плановая',
        'user_name': 'Иванов',
        'created_at': '2025-10-06 12:00:00',
        'status_code': 'in_progress',
        'status_label': 'В работе',
        'found': '7',
        'not_found': 3,
        'total': 10.0,
      });

      expect(model.id, '12');
      expect(model.responsibleName, 'Иванов');
      expect(model.foundCount, 7);
      expect(model.missingCount, 3);
      expect(model.totalCount, 10);
      expect(model.isClosed, isFalse);
    });

    test('InventoryTaskModel joins the employee name', () {
      final task = InventoryTaskModel.fromJson(const {
        'id': '1',
        'inventory_id': '12',
        'location': 'Склад 1',
        'common_status': 'Открыта',
        'last_name': 'Иванов',
        'first_name': 'Иван',
        'middle_name': null,
        'found': null,
        'total': '4',
      });

      expect(task.employeeName, 'Иванов Иван');
      expect(task.status, 'Открыта');
      expect(task.foundCount, 0);
      expect(task.totalCount, 4);
    });

    test('InventoryPlanModel normalizes EPCs and survives a round trip', () {
      final plan = InventoryPlanModel.fromJson(
        const {
          'success': true,
          'inventory_id': 12,
          'location_name': 'Склад 1',
          'expected_items': [
            {'epc': ' e2001 ', 'name': 'Стол'},
            {'epc': null, 'name': 'Без метки'},
          ],
        },
        inventoryId: '12',
      );

      expect(
        plan.expectedItems.first,
        const ExpectedItem(epc: 'E2001', name: 'Стол'),
      );
      expect(plan.expectedItems.last.epc, '');
      expect(
        InventoryPlanModel.fromJson(plan.toJson(), inventoryId: '12'),
        plan,
      );
    });

    test('InventoryPlanModel also reads fields nested in data', () {
      final plan = InventoryPlanModel.fromJson(
        const {
          'success': true,
          'data': {
            'expected_items': [
              {'epc': 'E1', 'name': 'A'},
            ],
          },
        },
        inventoryId: '5',
      );

      expect(plan.inventoryId, '5');
      expect(plan.expectedItems, hasLength(1));
    });
  });

  group('InventoryReconciliation', () {
    const plan = InventoryPlan(
      inventoryId: '1',
      locationName: '',
      expectedItems: [
        ExpectedItem(epc: 'E1', name: 'Стол'),
        ExpectedItem(epc: 'E2', name: 'Стул'),
        ExpectedItem(epc: 'E3', name: 'Шкаф'),
      ],
    );

    test('splits the plan into found and missing, and lists extra tags', () {
      final result = InventoryReconciliation.compute(
        plan: plan,
        scannedEpcs: const ['E9', 'E2', 'E1', 'E8'],
      );

      expect(result.found.map((item) => item.epc), ['E1', 'E2']);
      expect(result.missing.map((item) => item.epc), ['E3']);
      expect(result.extraEpcs, ['E9', 'E8']);
      expect(result.expectedCount, 3);
    });

    test('without a plan every tag is extra', () {
      final result = InventoryReconciliation.compute(
        plan: const InventoryPlan.empty('1'),
        scannedEpcs: const ['E1'],
      );

      expect(result.found, isEmpty);
      expect(result.missing, isEmpty);
      expect(result.extraEpcs, ['E1']);
    });
  });

  group('InventoryRepositoryImpl', () {
    late _MockRemote remote;
    late InventoryLocalDataSource local;
    late InventoryRepositoryImpl repository;

    setUp(() {
      remote = _MockRemote();
      local = InventoryLocalDataSource(InMemoryKeyValueStore());
      repository = InventoryRepositoryImpl(remote, local);
    });

    test('hides closed inventories and remembers names', () async {
      when(() => remote.getInventories()).thenAnswer(
        (_) async => [_inventory('1'), _inventory('2', status: 'closed')],
      );

      final result = await repository.getActiveInventories();

      expect(result.valueOrNull!.map((i) => i.id), ['1']);
      expect(repository.findInventoryName('2'), 'INV-2');
    });

    test('falls back to the cached plan when offline', () async {
      const fresh = InventoryPlanModel(
        inventoryId: '1',
        locationName: 'Склад',
        expectedItems: [ExpectedItem(epc: 'E1', name: 'Стол')],
      );
      when(() => remote.getPlan('1')).thenAnswer((_) async => fresh);
      await repository.getPlan('1');

      when(() => remote.getPlan('1')).thenThrow(const FormatException('x'));
      final result = await repository.getPlan('1');

      expect(result.valueOrNull!.isFromCache, isTrue);
      expect(result.valueOrNull!.plan, fresh);
    });

    test('reports the failure when there is no cached plan', () async {
      when(() => remote.getPlan('1')).thenThrow(const FormatException('x'));

      final result = await repository.getPlan('1');

      expect(result.failureOrNull, isA<ParsingFailure>());
    });

    test('finishing deletes the draft and announces the change', () async {
      when(
        () => remote.finishInventory(
          inventoryId: '1',
          scannedEpcs: ['E1'],
          duration: Duration.zero,
        ),
      ).thenAnswer((_) async {});
      await repository.saveDraft('1', ['E1']);
      final changes = expectLater(repository.changes, emits(null));

      final result = await repository.finishInventory(
        inventoryId: '1',
        scannedEpcs: ['E1'],
        duration: Duration.zero,
      );

      expect(result.isSuccess, isTrue);
      expect(repository.readDraft('1'), isNull);
      await changes;
    });

    test('keeps the draft when finishing fails', () async {
      when(
        () => remote.finishInventory(
          inventoryId: any(named: 'inventoryId'),
          scannedEpcs: any(named: 'scannedEpcs'),
          duration: any(named: 'duration'),
        ),
      ).thenThrow(const FormatException('x'));
      await repository.saveDraft('1', ['E1']);

      final result = await repository.finishInventory(
        inventoryId: '1',
        scannedEpcs: ['E1'],
        duration: Duration.zero,
      );

      expect(result.isSuccess, isFalse);
      expect(repository.readDraft('1')!.scannedEpcs, ['E1']);
    });
  });
}
