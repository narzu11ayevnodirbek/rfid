import 'package:rfid/core/error/failure.dart';

/// The outcome of an operation that can fail: a value or a [Failure].
///
/// ```dart
/// final result = await repository.getInventories();
/// switch (result) {
///   case Success(:final value): emit(LoadSuccess(value));
///   case Failed(:final failure): emit(LoadFailure(failure));
/// }
/// ```
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Failed<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Failed<T>(:final failure) => failure,
      };
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;
}
