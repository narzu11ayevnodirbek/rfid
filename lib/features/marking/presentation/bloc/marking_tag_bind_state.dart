part of 'marking_tag_bind_bloc.dart';

class MarkingTagBindState extends Equatable {
  const MarkingTagBindState({
    this.item = const LoadInProgress<MarkingItem>(),
    this.photoPath = '',
    this.scan = const TagScanState(),
    this.submitStatus = SubmitStatus.idle,
    this.submitFailure,
  });

  final LoadState<MarkingItem> item;
  final String photoPath;
  final TagScanState scan;
  final SubmitStatus submitStatus;
  final Failure? submitFailure;

  String? get tagToBind => scan.lastTag;

  bool get canSubmit =>
      tagToBind != null &&
      item is LoadSuccess<MarkingItem> &&
      !submitStatus.isSubmitting;

  MarkingTagBindState copyWith({
    LoadState<MarkingItem>? item,
    String? photoPath,
    TagScanState? scan,
    SubmitStatus? submitStatus,
    Failure? submitFailure,
  }) {
    return MarkingTagBindState(
      item: item ?? this.item,
      photoPath: photoPath ?? this.photoPath,
      scan: scan ?? this.scan,
      submitStatus: submitStatus ?? this.submitStatus,
      submitFailure: (submitStatus ?? this.submitStatus) == SubmitStatus.failed
          ? submitFailure ?? this.submitFailure
          : null,
    );
  }

  @override
  List<Object?> get props =>
      [item, photoPath, scan, submitStatus, submitFailure];
}
