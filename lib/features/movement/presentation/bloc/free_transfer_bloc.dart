import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/core/rfid/tag_scan_state.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';
import 'package:rfid/features/movement/domain/repositories/movement_repository.dart';

part 'free_transfer_event.dart';
part 'free_transfer_state.dart';

class FreeTransferBloc extends Bloc<FreeTransferEvent, FreeTransferState> {
  FreeTransferBloc({
    required MovementRepository repository,
    required RfidReader reader,
    TagScanSession? scanSession,
  })  : _repository = repository,
        _scan = scanSession ??
            TagScanSession(
              reader: reader,
              powerProfile: RfidPowerProfile.movement,
            ),
        super(const FreeTransferState()) {
    on<FreeTransferLocationsRequested>(_onLocationsRequested);
    on<FreeTransferLocationSelected>(
      (event, emit) => emit(
        state.copyWith(
          selectedLocation: event.location,
          showLocationRequired: false,
        ),
      ),
    );
    on<FreeTransferScanToggled>((event, emit) => _scan.toggle());
    on<FreeTransferTagRemoved>((event, emit) => _scan.remove(event.epc));
    on<FreeTransferTagsCleared>((event, emit) => _scan.clear());
    on<FreeTransferSubmitted>(_onSubmitted);
    on<_ScanStateChanged>(
      (event, emit) => emit(state.copyWith(scan: event.scan)),
    );

    _scanSubscription =
        _scan.states.listen((scan) => add(_ScanStateChanged(scan)));
  }

  final MovementRepository _repository;
  final TagScanSession _scan;
  late final StreamSubscription<TagScanState> _scanSubscription;

  Future<void> _onLocationsRequested(
    FreeTransferLocationsRequested event,
    Emitter<FreeTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        locations: const LoadInProgress<List<StorageLocation>>(),
      ),
    );
    final result = await _repository.getLocations();
    emit(
      state.copyWith(
        locations: switch (result) {
          Success(:final value) => LoadSuccess(value),
          Failed(:final failure) => LoadFailure(failure),
        },
      ),
    );
  }

  Future<void> _onSubmitted(
    FreeTransferSubmitted event,
    Emitter<FreeTransferState> emit,
  ) async {
    final location = state.selectedLocation;
    if (location == null) {
      emit(state.copyWith(showLocationRequired: true));
      return;
    }
    if (!state.canSubmit) return;
    await _scan.stop();
    emit(state.copyWith(submitStatus: SubmitStatus.submitting));
    final result = await _repository.moveFreely(
      locationId: location.id,
      scannedEpcs: state.scan.tags,
    );
    switch (result) {
      case Success(:final value):
        _scan.clear();
        emit(
          state.copyWith(submitStatus: SubmitStatus.succeeded, result: value),
        );
      case Failed(:final failure):
        emit(
          state.copyWith(
            submitStatus: SubmitStatus.failed,
            submitFailure: failure,
          ),
        );
    }
  }

  @override
  Future<void> close() async {
    await _scanSubscription.cancel();
    await _scan.dispose();
    return super.close();
  }
}
