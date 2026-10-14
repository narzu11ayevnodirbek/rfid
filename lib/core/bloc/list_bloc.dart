import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/error/result.dart';

sealed class ListEvent {
  const ListEvent();
}

/// First load, or a retry after a failure. Shows the loading indicator.
final class ListLoadRequested extends ListEvent {
  const ListLoadRequested();
}

/// Reload while the current items stay on screen (pull-to-refresh).
final class ListRefreshRequested extends ListEvent {
  const ListRefreshRequested([this._done]);

  final Completer<void>? _done;
}

/// Base for every screen that shows a list loaded from the server.
///
/// A subclass only says where the items come from:
///
/// ```dart
/// class InventoryListBloc extends ListBloc<Inventory> {
///   InventoryListBloc(this._repository)
///       : super(invalidations: _repository.changes);
///
///   final InventoryRepository _repository;
///
///   @override
///   Future<Result<List<Inventory>>> fetchItems() =>
///       _repository.getActiveInventories();
/// }
/// ```
///
/// Loading, retry, pull-to-refresh and "reload when the data changed
/// elsewhere" then work the same way on every list screen.
abstract class ListBloc<T> extends Bloc<ListEvent, LoadState<List<T>>> {
  /// [invalidations] fires when the list on the server may have changed, for
  /// example after a successful submit on a detail screen.
  ListBloc({Stream<void>? invalidations}) : super(LoadInProgress<List<T>>()) {
    on<ListLoadRequested>(_onLoadRequested);
    on<ListRefreshRequested>(_onRefreshRequested);
    _invalidationSubscription = invalidations?.listen(
      (_) => add(const ListRefreshRequested()),
    );
  }

  StreamSubscription<void>? _invalidationSubscription;

  @protected
  Future<Result<List<T>>> fetchItems();

  /// Reloads the list; the future completes when the reload has finished.
  /// Made for `RefreshIndicator.onRefresh`.
  Future<void> refresh() {
    final done = Completer<void>();
    add(ListRefreshRequested(done));
    return done.future;
  }

  Future<void> _onLoadRequested(
    ListLoadRequested event,
    Emitter<LoadState<List<T>>> emit,
  ) async {
    // Not `const`: a constant cannot carry the type parameter `T`.
    emit(LoadInProgress<List<T>>());
    emit(_toState(await fetchItems()));
  }

  Future<void> _onRefreshRequested(
    ListRefreshRequested event,
    Emitter<LoadState<List<T>>> emit,
  ) async {
    try {
      final current = state;
      if (current is LoadInProgress<List<T>>) return;
      if (current is LoadSuccess<List<T>>) {
        if (current.isRefreshing) return;
        emit(LoadSuccess(current.value, isRefreshing: true));
      }

      final result = await fetchItems();
      final previous = current.valueOrNull;
      switch (result) {
        case Success(:final value):
          emit(LoadSuccess(value));
        case Failed(:final failure) when previous != null:
          // Keep what the user already sees and report the failure aside.
          emit(LoadSuccess(previous, refreshFailure: failure));
        case Failed(:final failure):
          emit(LoadFailure(failure));
      }
    } finally {
      event._done?.complete();
    }
  }

  LoadState<List<T>> _toState(Result<List<T>> result) => switch (result) {
        Success(:final value) => LoadSuccess(value),
        Failed(:final failure) => LoadFailure(failure),
      };

  @override
  Future<void> close() async {
    await _invalidationSubscription?.cancel();
    return super.close();
  }
}
