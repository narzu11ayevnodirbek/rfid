part of 'free_transfer_bloc.dart';

class FreeTransferState extends Equatable {
  const FreeTransferState({
    this.locations = const LoadInProgress<List<StorageLocation>>(),
    this.selectedLocation,
    this.showLocationRequired = false,
    this.scan = const TagScanState(),
    this.submitStatus = SubmitStatus.idle,
    this.result,
    this.submitFailure,
  });

  final LoadState<List<StorageLocation>> locations;
  final StorageLocation? selectedLocation;

  /// The user tried to send without choosing where to.
  final bool showLocationRequired;
  final TagScanState scan;
  final SubmitStatus submitStatus;
  final TransferResult? result;
  final Failure? submitFailure;

  bool get canSubmit => scan.hasTags && !submitStatus.isSubmitting;

  FreeTransferState copyWith({
    LoadState<List<StorageLocation>>? locations,
    StorageLocation? selectedLocation,
    bool? showLocationRequired,
    TagScanState? scan,
    SubmitStatus? submitStatus,
    TransferResult? result,
    Failure? submitFailure,
  }) {
    final status = submitStatus ?? this.submitStatus;
    return FreeTransferState(
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      showLocationRequired: showLocationRequired ?? this.showLocationRequired,
      scan: scan ?? this.scan,
      submitStatus: status,
      result: status == SubmitStatus.succeeded ? result ?? this.result : null,
      submitFailure: status == SubmitStatus.failed
          ? submitFailure ?? this.submitFailure
          : null,
    );
  }

  @override
  List<Object?> get props => [
        locations,
        selectedLocation,
        showLocationRequired,
        scan,
        submitStatus,
        result,
        submitFailure,
      ];
}
