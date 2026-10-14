import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/bloc/list_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';

class _NumbersBloc extends ListBloc<int> {
  _NumbersBloc(this._responses, {super.invalidations});

  /// Answers handed out one per fetch, in order.
  final List<Result<List<int>>> _responses;
  int fetchCount = 0;

  @override
  Future<Result<List<int>>> fetchItems() async => _responses[fetchCount++];
}

void main() {
  const failure = NetworkFailure();

  blocTest<_NumbersBloc, LoadState<List<int>>>(
    'starts in the loading state',
    build: () => _NumbersBloc([]),
    verify: (bloc) => expect(bloc.state, const LoadInProgress<List<int>>()),
  );

  blocTest<_NumbersBloc, LoadState<List<int>>>(
    'loads the items',
    build: () => _NumbersBloc([
      const Success([1, 2]),
    ]),
    act: (bloc) => bloc.add(const ListLoadRequested()),
    expect: () => const [
      LoadInProgress<List<int>>(),
      LoadSuccess([1, 2]),
    ],
  );

  blocTest<_NumbersBloc, LoadState<List<int>>>(
    'reports a failed load, then recovers on retry',
    build: () => _NumbersBloc([
      const Failed(failure),
      const Success([3]),
    ]),
    act: (bloc) async {
      bloc.add(const ListLoadRequested());
      await pumpEventQueue();
      bloc.add(const ListLoadRequested());
    },
    expect: () => const [
      LoadInProgress<List<int>>(),
      LoadFailure<List<int>>(failure),
      LoadInProgress<List<int>>(),
      LoadSuccess([3]),
    ],
  );

  blocTest<_NumbersBloc, LoadState<List<int>>>(
    'refresh keeps the current items on screen while reloading',
    build: () => _NumbersBloc([
      const Success([1]),
      const Success([1, 2]),
    ]),
    act: (bloc) async {
      bloc.add(const ListLoadRequested());
      await pumpEventQueue();
      await bloc.refresh();
    },
    skip: 2,
    expect: () => const [
      LoadSuccess([1], isRefreshing: true),
      LoadSuccess([1, 2]),
    ],
  );

  blocTest<_NumbersBloc, LoadState<List<int>>>(
    'a failed refresh keeps the old items and reports the failure',
    build: () => _NumbersBloc([
      const Success([1]),
      const Failed(failure),
    ]),
    act: (bloc) async {
      bloc.add(const ListLoadRequested());
      await pumpEventQueue();
      await bloc.refresh();
    },
    skip: 3,
    expect: () => const [
      LoadSuccess([1], refreshFailure: failure),
    ],
  );

  test('reloads when the repository announces a change', () async {
    final invalidations = StreamController<void>.broadcast();
    final bloc = _NumbersBloc(
      [
        const Success([1]),
        const Success([1, 2]),
      ],
      invalidations: invalidations.stream,
    )..add(const ListLoadRequested());
    await pumpEventQueue();

    invalidations.add(null);
    await pumpEventQueue();

    expect(bloc.fetchCount, 2);
    expect(bloc.state, const LoadSuccess([1, 2]));

    await bloc.close();
    await invalidations.close();
  });
}
