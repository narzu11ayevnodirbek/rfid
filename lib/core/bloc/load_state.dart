import 'package:equatable/equatable.dart';
import 'package:rfid/core/error/failure.dart';

sealed class LoadState<T> extends Equatable {
  const LoadState();

  T? get valueOrNull => switch (this) {
        LoadSuccess<T>(:final value) => value,
        _ => null,
      };
}

final class LoadInProgress<T> extends LoadState<T> {
  const LoadInProgress();

  @override
  List<Object?> get props => const [];
}

final class LoadSuccess<T> extends LoadState<T> {
  const LoadSuccess(
    this.value, {
    this.isRefreshing = false,
    this.refreshFailure,
  });

  final T value;

  final bool isRefreshing;

  final Failure? refreshFailure;

  @override
  List<Object?> get props => [value, isRefreshing, refreshFailure];
}

final class LoadFailure<T> extends LoadState<T> {
  const LoadFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
