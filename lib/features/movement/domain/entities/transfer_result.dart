import 'package:equatable/equatable.dart';

/// What the server did with a batch of scanned tags.
///
/// A transfer can succeed partially: some items move, others are reported in
/// the lists below.
class TransferResult extends Equatable {
  const TransferResult({
    required this.movedCount,
    this.message,
    this.unknownEpcs = const [],
    this.notInSource = const [],
    this.alreadyHere = const [],
    this.blocked = const [],
  });

  final int movedCount;
  final String? message;

  /// Tags that belong to no item.
  final List<String> unknownEpcs;

  /// Items that are not in the task's source location.
  final List<String> notInSource;

  /// Items that already are in the target location.
  final List<String> alreadyHere;

  /// Items whose status forbids moving (written off, under repair, ...).
  final List<String> blocked;

  bool get hasProblems =>
      unknownEpcs.isNotEmpty ||
      notInSource.isNotEmpty ||
      alreadyHere.isNotEmpty ||
      blocked.isNotEmpty;

  @override
  List<Object?> get props =>
      [movedCount, message, unknownEpcs, notInSource, alreadyHere, blocked];
}
