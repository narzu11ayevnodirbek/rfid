import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/rfid/fake_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/core/session/user.dart';
import 'package:rfid/core/storage/in_memory_key_value_store.dart';
import 'package:rfid/features/movement/data/datasources/movement_remote_data_source.dart';
import 'package:rfid/features/movement/data/models/movement_task_model.dart';
import 'package:rfid/features/movement/data/models/transfer_result_model.dart';
import 'package:rfid/features/movement/data/repositories/movement_repository_impl.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';
import 'package:rfid/features/movement/domain/repositories/movement_repository.dart';
import 'package:rfid/features/movement/presentation/bloc/free_transfer_bloc.dart';
import 'package:rfid/features/movement/presentation/bloc/movement_scan_bloc.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockRepository extends Mock implements MovementRepository {}

const _task = MovementTask(
  id: '4',
  movementId: '40',
  name: 'Перемещение 40',
  status: '',
  sourceLocation: 'Склад',
  destination: 'Кабинет 5',
  executorName: '',
  createdAt: '',
  movedCount: 0,
  totalCount: 2,
);

TagScanSession _session(FakeRfidReader reader) => TagScanSession(
      reader: reader,
      powerProfile: RfidPowerProfile.movement,
      onNewTag: () {},
    );

void main() {
  setUpAll(() => registerFallbackValue(<String>[]));

  group('models', () {
    test('MovementTaskModel prefers explicit counters, falls back to items',
        () {
      final withCounters = MovementTaskModel.fromJson(const {
        'id': 4,
        'movement_id': 40,
        'name': 'Задание',
        'movement_name': 'Перемещение 40',
        'moved': '1',
        'total': '3',
        'moved_count': 2,
        'items_count': 5,
      });
      final withItems = MovementTaskModel.fromJson(const {
        'id': '5',
        'movement_id': '41',
        'items': [
          {'id': 1},
          {'id': 2},
        ],
      });

      expect(withCounters.name, 'Перемещение 40');
      expect(withCounters.movementId, '40');
      expect(withCounters.movedCount, 2);
      expect(withCounters.totalCount, 5);
      expect(withItems.totalCount, 2);
      expect(withItems.movedCount, 0);
    });

    test('TransferResultModel reads problems given as values or objects', () {
      final result = TransferResultModel.fromJson(const {
        'success': true,
        'moved_count': '3',
        'errors': {
          'unknown_epcs': ['E9'],
          'already_here': [
            {'name': 'Стол'},
          ],
          'blocked': [
            {'item_id': 7, 'status': 'repair'},
            'Стул',
          ],
        },
      });

      expect(result.movedCount, 3);
      expect(result.unknownEpcs, ['E9']);
      expect(result.alreadyHere, ['Стол']);
      expect(result.blocked, ['7', 'Стул']);
      expect(result.notInSource, isEmpty);
      expect(result.hasProblems, isTrue);
    });
  });

  group('MovementRepositoryImpl', () {
    test('free transfer is signed with the user and a UTC timestamp', () async {
      final api = _MockApiClient();
      when(() => api.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => {'success': true, 'moved_count': 1},
      );
      final session = SessionStorage(InMemoryKeyValueStore());
      await session.start(
        token: 't',
        user: const User(id: '12', login: 'op', username: 'Op'),
      );
      final repository = MovementRepositoryImpl(
        MovementRemoteDataSource(api),
        session,
        now: () => DateTime.utc(2025, 3, 4, 5, 6, 7),
      );
      final changes = expectLater(repository.changes, emits(null));

      final result = await repository.moveFreely(
        locationId: '9',
        scannedEpcs: ['E1'],
      );

      expect(result.valueOrNull!.movedCount, 1);
      final body = verify(
        () =>
            api.post('api/transfer_free.php', body: captureAny(named: 'body')),
      ).captured.single;
      expect(body, {
        'new_location_id': 9,
        'scanned_epcs': ['E1'],
        'user_id': 12,
        'timestamp': '2025-03-04 05:06:07',
      });
      await changes;
    });
  });

  group('MovementScanBloc', () {
    late _MockRepository repository;
    late FakeRfidReader reader;

    setUp(() {
      repository = _MockRepository();
      reader = FakeRfidReader();
      when(() => repository.getTask('4'))
          .thenAnswer((_) async => const Success(_task));
    });

    Future<MovementScanBloc> scanned(List<String> epcs) async {
      final bloc = MovementScanBloc(
        repository: repository,
        reader: reader,
        taskId: '4',
        scanSession: _session(reader),
      )..add(const MovementScanTaskRequested());
      await pumpEventQueue();
      bloc.add(const MovementScanToggled());
      await pumpEventQueue();
      epcs.forEach(reader.simulateTag);
      await pumpEventQueue();
      return bloc;
    }

    test('sends the tags against the movement id and clears them', () async {
      const result = TransferResult(movedCount: 2);
      when(
        () =>
            repository.moveForTask(movementId: '40', scannedEpcs: ['E1', 'E2']),
      ).thenAnswer((_) async => const Success(result));
      final bloc = await scanned(['E1', 'E2']);

      bloc.add(const MovementScanSubmitted());
      await pumpEventQueue();

      expect(bloc.state.submitStatus, SubmitStatus.succeeded);
      expect(bloc.state.result, result);
      expect(bloc.state.scan.tags, isEmpty);
      await bloc.close();
    });

    test('keeps the tags when the server refuses', () async {
      when(
        () => repository.moveForTask(
          movementId: any(named: 'movementId'),
          scannedEpcs: any(named: 'scannedEpcs'),
        ),
      ).thenAnswer(
        (_) async =>
            const Failed(ServerFailure(message: 'Неверный ID перемещения')),
      );
      final bloc = await scanned(['E1']);

      bloc.add(const MovementScanSubmitted());
      await pumpEventQueue();

      expect(bloc.state.submitStatus, SubmitStatus.failed);
      expect(bloc.state.scan.tags, ['E1']);
      await bloc.close();
    });
  });

  group('FreeTransferBloc', () {
    test('asks for a location before sending', () async {
      final repository = _MockRepository();
      final reader = FakeRfidReader();
      when(() => repository.getLocations()).thenAnswer(
        (_) async => const Success([
          StorageLocation(id: '9', name: 'Кабинет 5', path: ''),
        ]),
      );
      final bloc = FreeTransferBloc(
        repository: repository,
        reader: reader,
        scanSession: _session(reader),
      )..add(const FreeTransferLocationsRequested());
      await pumpEventQueue();
      bloc.add(const FreeTransferScanToggled());
      await pumpEventQueue();
      reader.simulateTag('E1');
      await pumpEventQueue();

      bloc.add(const FreeTransferSubmitted());
      await pumpEventQueue();

      expect(bloc.state.showLocationRequired, isTrue);
      verifyNever(
        () => repository.moveFreely(
          locationId: any(named: 'locationId'),
          scannedEpcs: any(named: 'scannedEpcs'),
        ),
      );
      await bloc.close();
    });
  });
}
