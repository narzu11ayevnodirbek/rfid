import 'package:equatable/equatable.dart';
import 'package:rfid/core/error/failure.dart';

class TagScanState extends Equatable {
  const TagScanState({
    this.tags = const [],
    this.isScanning = false,
    this.isReading = false,
    this.isBusy = false,
    this.lastTag,
    this.failure,
  });

  final List<String> tags;

  final bool isScanning;

  final bool isReading;

  final bool isBusy;

  final String? lastTag;

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
