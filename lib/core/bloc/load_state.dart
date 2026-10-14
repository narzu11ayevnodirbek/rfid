import 'package:equatable/equatable.dart';
import 'package:rfid/core/error/failure.dart';

/// The three states of anything that is loaded from the server.
///
/// Because a screen has to handle every case to compile (`switch` on a sealed
/// class), a request that fails can never leave a spinner on screen.
sealed class LoadState<T> extends Equatable {
  const LoadState();

  /// The loaded value, or `null` while loading or after a failure.
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

  /// A reload is running while [value] stays on screen.
  final bool isRefreshing;

  /// Set when the last reload failed; [value] is then the previous data.
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
