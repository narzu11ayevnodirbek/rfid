import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/rfid/fake_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_draft.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';
import 'package:rfid/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';

class _MockRepository extends Mock implements InventoryRepository {}

const _plan = InventoryPlan(
  inventoryId: '7',
  locationName: 'Склад',
  expectedItems: [
    ExpectedItem(epc: 'E1', name: 'Стол'),
    ExpectedItem(epc: 'E2', name: 'Стул'),
  ],
);

void main() {
  late _MockRepository repository;
  late FakeRfidReader reader;

  setUpAll(() => registerFallbackValue(Duration.zero));

  setUp(() {
    repository = _MockRepository();
    reader = FakeRfidReader();
    when(() => repository.findInventoryName('7')).thenReturn('0042');
    when(() => repository.readDraft('7')).thenReturn(null);
    when(() => repository.saveDraft(any(), any())).thenAnswer((_) async {});
    when(() => repository.getPlan('7')).thenAnswer(
      (_) async => const Success(
        LoadedInventoryPlan(plan: _plan, isFromCache: false),
      ),
    );
  });

  InventoryScanBloc buildBloc() => InventoryScanBloc(
        repository: repository,
        reader: reader,
        inventoryId: '7',
        draftSaveDelay: Duration.zero,
        scanSession: TagScanSession(
          reader: reader,
          powerProfile: RfidPowerProfile.inventory,
          onNewTag: () {},
        ),
      );

  test('loads the plan and shows the inventory name', () async {
    final bloc = buildBloc()..add(const InventoryScanStarted());
    await pumpEventQueue();

    expect(bloc.state.title, '0042');
    expect(bloc.state.plan, _plan);
    expect(bloc.state.reconciliation.missing, hasLength(2));
    await bloc.close();
  });

  test('restores a draft and counts it against the plan', () async {
    when(() => repository.readDraft('7')).thenReturn(
      InventoryDraft(scannedEpcs: const ['E1', 'E9'], savedAt: DateTime(2025)),
    );

    final bloc = buildBloc()..add(const InventoryScanStarted());
    await pumpEventQueue();

    expect(bloc.state.restoredDraftCount, 2);
    expect(bloc.state.reconciliation.found.single.epc, 'E1');
    expect(bloc.state.reconciliation.extraEpcs, ['E9']);
    await bloc.close();
  });

  test('scanning updates the result and saves a draft', () async {
    final bloc = buildBloc()..add(const InventoryScanStarted());
    await pumpEventQueue();

    bloc.add(const InventoryScanToggled());
    await pumpEventQueue();
    reader
      ..simulateTag('e2')
      ..simulateTag('E5');
    await pumpEventQueue();
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.reconciliation.found.single.epc, 'E2');
    expect(bloc.state.reconciliation.extraEpcs, ['E5']);
    verify(() => repository.saveDraft('7', ['E2', 'E5'])).called(1);
    await bloc.close();
  });

  test('works without a plan when it cannot be loaded', () async {
    when(() => repository.getPlan('7'))
        .thenAnswer((_) async => const Failed(NetworkFailure()));

    final bloc = buildBloc()..add(const InventoryScanStarted());
    await pumpEventQueue();
    bloc.add(const InventoryScanToggled());
    await pumpEventQueue();
    reader.simulateTag('E1');
    await pumpEventQueue();

    expect(bloc.state.planFailure, const NetworkFailure());
    expect(bloc.state.reconciliation.extraEpcs, ['E1']);
    await bloc.close();
  });

  test('finishing sends the tags and stops the reader', () async {
    when(
      () => repository.finishInventory(
        inventoryId: '7',
        scannedEpcs: ['E1'],
        duration: any(named: 'duration'),
      ),
    ).thenAnswer((_) async => const Success(null));
    final bloc = buildBloc()..add(const InventoryScanStarted());
    await pumpEventQueue();
    bloc.add(const InventoryScanToggled());
    await pumpEventQueue();
    reader.simulateTag('E1');
    await pumpEventQueue();

    bloc.add(const InventoryScanFinishConfirmed());
    await pumpEventQueue();

    expect(bloc.state.submitStatus, SubmitStatus.succeeded);
    expect(reader.isScanning, isFalse);
    await bloc.close();
  });

  test('a failed finish keeps the draft and reports why', () async {
    when(
      () => repository.finishInventory(
        inventoryId: any(named: 'inventoryId'),
        scannedEpcs: any(named: 'scannedEpcs'),
        duration: any(named: 'duration'),
      ),
    ).thenAnswer((_) async => const Failed(NetworkFailure()));
    final bloc = buildBloc()..add(const InventoryScanStarted());
    await pumpEventQueue();

    bloc.add(const InventoryScanFinishConfirmed());
    await pumpEventQueue();

    expect(bloc.state.submitStatus, SubmitStatus.failed);
    expect(bloc.state.submitFailure, const NetworkFailure());
    verify(() => repository.saveDraft('7', const [])).called(1);
    await bloc.close();
  });

  test('closing the screen stops the reader', () async {
    final bloc = buildBloc()..add(const InventoryScanStarted());
    await pumpEventQueue();
    bloc.add(const InventoryScanToggled());
    await pumpEventQueue();

    await bloc.close();

    expect(reader.isScanning, isFalse);
  });
}
