import 'package:equatable/equatable.dart';

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

  final List<String> unknownEpcs;

  final List<String> notInSource;

  final List<String> alreadyHere;

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
