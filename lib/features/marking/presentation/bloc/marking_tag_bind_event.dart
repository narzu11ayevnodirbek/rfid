part of 'marking_tag_bind_bloc.dart';

sealed class MarkingTagBindEvent {
  const MarkingTagBindEvent();
}

/// Load (or reload after a failure) the item and its photo.
final class MarkingTagBindItemRequested extends MarkingTagBindEvent {
  const MarkingTagBindItemRequested();
}

final class MarkingTagBindScanToggled extends MarkingTagBindEvent {
  const MarkingTagBindScanToggled();
}

/// Bind the last read tag to the item.
final class MarkingTagBindSubmitted extends MarkingTagBindEvent {
  const MarkingTagBindSubmitted();
}

final class _ScanStateChanged extends MarkingTagBindEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}
