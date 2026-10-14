import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/error/result.dart';

sealed class LoadEvent {
  const LoadEvent();
}

/// First load, or a retry after a failure. Shows the loading indicator.
final class LoadRequested extends LoadEvent {
  const LoadRequested();
}

/// Reload while the current data stays on screen (pull-to-refresh).
final class RefreshRequested extends LoadEvent {
  const RefreshRequested([this._done]);

  final Completer<void>? _done;
}

/// Base for every screen that shows data loaded from the server.
///
/// A subclass only says where the data comes from:
///
/// ```dart
/// class InventoryListBloc extends ListBloc<Inventory> {
///   InventoryListBloc(this._repository)
///       : super(invalidations: _repository.changes);
///
///   final InventoryRepository _repository;
///
///   @override
///   Future<Result<List<Inventory>>> load() =>
///       _repository.getActiveInventories();
/// }
/// ```
///
/// Loading, retry, pull-to-refresh and "reload when the data changed
/// elsewhere" then work the same way on every screen.
abstract class LoadBloc<T> extends Bloc<LoadEvent, LoadState<T>> {
  /// [invalidations] fires when the data on the server may have changed, for
  /// example after a successful submit on another screen.
  LoadBloc({Stream<void>? invalidations}) : super(LoadInProgress<T>()) {
    on<LoadRequested>(_onLoadRequested);
    on<RefreshRequested>(_onRefreshRequested);
    _invalidationSubscription = invalidations?.listen(
      (_) => add(const RefreshRequested()),
    );
  }

  StreamSubscription<void>? _invalidationSubscription;

  @protected
  Future<Result<T>> load();

  /// Reloads; the future completes when the reload has finished.
  /// Made for `RefreshIndicator.onRefresh`.
  Future<void> refresh() {
    final done = Completer<void>();
    add(RefreshRequested(done));
    return done.future;
  }

  Future<void> _onLoadRequested(
    LoadRequested event,
    Emitter<LoadState<T>> emit,
  ) async {
    // Not `const`: a constant cannot carry the type parameter `T`.
    emit(LoadInProgress<T>());
    emit(
      switch (await load()) {
        Success(:final value) => LoadSuccess(value),
        Failed(:final failure) => LoadFailure(failure),
      },
    );
  }

  Future<void> _onRefreshRequested(
    RefreshRequested event,
    Emitter<LoadState<T>> emit,
  ) async {
    try {
      final current = state;
      if (current is LoadInProgress<T>) return;
      if (current is LoadSuccess<T>) {
        if (current.isRefreshing) return;
        emit(LoadSuccess(current.value, isRefreshing: true));
      }

      final result = await load();
      switch ((result, current)) {
        case (Success(:final value), _):
          emit(LoadSuccess(value));
        case (Failed(:final failure), LoadSuccess<T>(:final value)):
          // Keep what the user already sees and report the failure aside.
          emit(LoadSuccess(value, refreshFailure: failure));
        case (Failed(:final failure), _):
          emit(LoadFailure(failure));
      }
    } finally {
      event._done?.complete();
    }
  }

  @override
  Future<void> close() async {
    await _invalidationSubscription?.cancel();
    return super.close();
  }
}

/// [LoadBloc] for a list; `ListBlocView` renders it.
abstract class ListBloc<T> extends LoadBloc<List<T>> {
  ListBloc({super.invalidations});
}
