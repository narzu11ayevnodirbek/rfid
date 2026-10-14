import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/rfid/fake_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/features/marking/data/datasources/marking_remote_data_source.dart';
import 'package:rfid/features/marking/data/models/marking_task_model.dart';
import 'package:rfid/features/marking/data/repositories/marking_repository_impl.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_tag_bind_bloc.dart';

class _MockRemote extends Mock implements MarkingRemoteDataSource {}

MarkingTaskModel _task({String? boundEpc}) => MarkingTaskModel.fromJson({
      'id': 10,
      'marking_id': '3',
      'name': 'Этаж 2',
      'executor_name': 'Иванов',
      'marked': 0,
      'total': '2',
      'items': [
        const {'item_id': 100, 'name': 'Стол', 'inventory_number': 'INV-100'},
        {
          'id': '101',
          'name': 'Стул',
          'barcode': 'INV-101',
          'rfid': boundEpc,
          'photo_path': 'uploads/101.jpg',
        },
      ],
    });

void main() {
  group('MarkingTaskModel', () {
    test('reads nested items and counts bound ones', () {
      final task = _task(boundEpc: 'e9');

      expect(task.id, '10');
      expect(task.items.map((item) => item.id), ['100', '101']);
      expect(task.items.last.inventoryNumber, 'INV-101');
      expect(task.items.last.boundEpc, 'E9');
      expect(task.totalCount, 2);
      expect(task.boundCount, 1);
    });
  });

  group('MarkingRepositoryImpl', () {
    late _MockRemote remote;
    late MarkingRepositoryImpl repository;

    setUp(() {
      remote = _MockRemote();
      repository = MarkingRepositoryImpl(remote);
      when(() => remote.getTasks('3')).thenAnswer((_) async => [_task()]);
    });

    test('a bound tag shows up even before the server reports it', () async {
      when(
        () => remote.bindTag(
          markingId: '3',
          taskId: '10',
          itemId: '100',
          epc: 'E1',
        ),
      ).thenAnswer((_) async {});
      final changes = expectLater(repository.changes, emits(null));

      final result = await repository.bindTag(
        markingId: '3',
        taskId: '10',
        itemId: '100',
        epc: 'E1',
      );
      final task = await repository.getTask(markingId: '3', taskId: '10');

      expect(result.isSuccess, isTrue);
      expect(task.valueOrNull!.findItem('100')!.boundEpc, 'E1');
      expect(task.valueOrNull!.boundCount, 1);
      await changes;
    });

    test('finds an item of a loaded task', () async {
      await repository.getTasks('3');

      final item = await repository.getItem(
        markingId: '3',
        taskId: '10',
        itemId: '101',
      );

      expect(item.valueOrNull!.name, 'Стул');
      verify(() => remote.getTasks('3')).called(1);
    });
  });

  group('MarkingTagBindBloc', () {
    late _MockRemote remote;
    late FakeRfidReader reader;

    MarkingTagBindBloc build() => MarkingTagBindBloc(
          repository: MarkingRepositoryImpl(remote),
          reader: reader,
          markingId: '3',
          taskId: '10',
          itemId: '100',
          scanSession: TagScanSession(
            reader: reader,
            powerProfile: RfidPowerProfile.marking,
            onNewTag: () {},
          ),
        );

    setUp(() {
      remote = _MockRemote();
      reader = FakeRfidReader();
      when(() => remote.getTasks('3')).thenAnswer((_) async => [_task()]);
      when(() => remote.getItemPhotoPath(markingId: '3', itemId: '100'))
          .thenAnswer((_) async => 'uploads/100.jpg');
    });

    Future<MarkingTagBindBloc> scanned(List<String> epcs) async {
      final bloc = build()..add(const MarkingTagBindItemRequested());
      await pumpEventQueue();
      bloc.add(const MarkingTagBindScanToggled());
      await pumpEventQueue();
      epcs.forEach(reader.simulateTag);
      await pumpEventQueue();
      return bloc;
    }

    test('loads the item and its photo', () async {
      final bloc = build()..add(const MarkingTagBindItemRequested());
      await pumpEventQueue();

      expect(bloc.state.item.valueOrNull!.name, 'Стол');
      expect(bloc.state.photoPath, 'uploads/100.jpg');
      expect(bloc.state.canSubmit, isFalse);
      await bloc.close();
    });

    test('binds the most recently read tag', () async {
      when(
        () => remote.bindTag(
          markingId: '3',
          taskId: '10',
          itemId: '100',
          epc: 'E2',
        ),
      ).thenAnswer((_) async {});
      final bloc = await scanned(['E1', 'E2']);

      expect(bloc.state.tagToBind, 'E2');
      bloc.add(const MarkingTagBindSubmitted());
      await pumpEventQueue();

      expect(bloc.state.submitStatus, SubmitStatus.succeeded);
      expect(reader.isScanning, isFalse);
      await bloc.close();
    });

    test('shows why binding failed', () async {
      when(
        () => remote.bindTag(
          markingId: any(named: 'markingId'),
          taskId: any(named: 'taskId'),
          itemId: any(named: 'itemId'),
          epc: any(named: 'epc'),
        ),
      ).thenThrow(const ApiException(message: 'Метка уже используется'));
      final bloc = await scanned(['E1']);

      bloc.add(const MarkingTagBindSubmitted());
      await pumpEventQueue();

      expect(bloc.state.submitStatus, SubmitStatus.failed);
      expect(
        bloc.state.submitFailure,
        const ServerFailure(message: 'Метка уже используется'),
      );
      await bloc.close();
    });
  });
}
