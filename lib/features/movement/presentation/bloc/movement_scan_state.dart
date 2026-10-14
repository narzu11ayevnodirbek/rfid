part of 'movement_scan_bloc.dart';

class MovementScanState extends Equatable {
  const MovementScanState({
    this.task = const LoadInProgress<MovementTask>(),
    this.scan = const TagScanState(),
    this.submitStatus = SubmitStatus.idle,
    this.result,
    this.submitFailure,
  });

  final LoadState<MovementTask> task;
  final TagScanState scan;
  final SubmitStatus submitStatus;

  /// What the server reported after the last successful send.
  final TransferResult? result;
  final Failure? submitFailure;

  bool get canSubmit =>
      scan.hasTags &&
      task is LoadSuccess<MovementTask> &&
      !submitStatus.isSubmitting;

  MovementScanState copyWith({
    LoadState<MovementTask>? task,
    TagScanState? scan,
    SubmitStatus? submitStatus,
    TransferResult? result,
    Failure? submitFailure,
  }) {
    final status = submitStatus ?? this.submitStatus;
    return MovementScanState(
      task: task ?? this.task,
      scan: scan ?? this.scan,
      submitStatus: status,
      result: status == SubmitStatus.succeeded ? result ?? this.result : null,
      submitFailure: status == SubmitStatus.failed
          ? submitFailure ?? this.submitFailure
          : null,
    );
  }

  @override
  List<Object?> get props => [task, scan, submitStatus, result, submitFailure];
}
