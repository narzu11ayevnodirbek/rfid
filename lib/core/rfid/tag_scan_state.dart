import 'package:equatable/equatable.dart';
import 'package:rfid/core/error/failure.dart';

/// What a scan screen needs to know about its reader session.
///
/// Every scan bloc keeps one of these in its own state and passes it to
/// `ScanControlBar`, so all scan screens look and behave the same.
class TagScanState extends Equatable {
  const TagScanState({
    this.tags = const [],
    this.isScanning = false,
    this.isReading = false,
    this.isBusy = false,
    this.lastTag,
    this.failure,
  });

  /// Distinct EPCs in the order they were first read.
  final List<String> tags;

  /// The session is on: the operator pressed "Start" and not "Stop".
  final bool isScanning;

  /// The radio is reading right now (it may pause while the trigger is up).
  final bool isReading;

  /// A start or stop command is in progress.
  final bool isBusy;

  /// The most recently read EPC, even if it was read before.
  final String? lastTag;

  /// Why the last start failed, if it did.
  final RfidFailure? failure;

  bool get hasTags => tags.isNotEmpty;

  TagScanState copyWith({
    List<String>? tags,
    bool? isScanning,
    bool? isReading,
    bool? isBusy,
    String? lastTag,
    RfidFailure? failure,
    bool clearLastTag = false,
    bool clearFailure = false,
  }) {
    return TagScanState(
      tags: tags ?? this.tags,
      isScanning: isScanning ?? this.isScanning,
      isReading: isReading ?? this.isReading,
      isBusy: isBusy ?? this.isBusy,
      lastTag: clearLastTag ? null : lastTag ?? this.lastTag,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props =>
      [tags, isScanning, isReading, isBusy, lastTag, failure];
}
