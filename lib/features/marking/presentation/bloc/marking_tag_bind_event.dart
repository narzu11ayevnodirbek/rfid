part of 'marking_tag_bind_bloc.dart';

sealed class MarkingTagBindEvent {
  const MarkingTagBindEvent();
}

final class MarkingTagBindItemRequested extends MarkingTagBindEvent {
  const MarkingTagBindItemRequested();
}

final class MarkingTagBindScanToggled extends MarkingTagBindEvent {
  const MarkingTagBindScanToggled();
}

final class MarkingTagBindSubmitted extends MarkingTagBindEvent {
  const MarkingTagBindSubmitted();
}

final class _ScanStateChanged extends MarkingTagBindEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}
