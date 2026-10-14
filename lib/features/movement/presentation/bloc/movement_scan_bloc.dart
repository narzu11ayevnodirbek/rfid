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
import 'package:rfid/features/movement/domain/entities/movement_task.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';
import 'package:rfid/features/movement/domain/repositories/movement_repository.dart';

part 'movement_scan_event.dart';
part 'movement_scan_state.dart';

class MovementScanBloc extends Bloc<MovementScanEvent, MovementScanState> {
  MovementScanBloc({
    required MovementRepository repository,
    required RfidReader reader,
    required this.taskId,
    TagScanSession? scanSession,
  })  : _repository = repository,
        _scan = scanSession ??
            TagScanSession(
              reader: reader,
              powerProfile: RfidPowerProfile.movement,
            ),
        super(const MovementScanState()) {
    on<MovementScanTaskRequested>(_onTaskRequested);
    on<MovementScanToggled>((event, emit) => _scan.toggle());
    on<MovementScanTagRemoved>((event, emit) => _scan.remove(event.epc));
    on<MovementScanTagsCleared>((event, emit) => _scan.clear());
    on<MovementScanSubmitted>(_onSubmitted);
    on<_ScanStateChanged>(
      (event, emit) => emit(state.copyWith(scan: event.scan)),
    );

    _scanSubscription =
        _scan.states.listen((scan) => add(_ScanStateChanged(scan)));
  }

  final MovementRepository _repository;
  final TagScanSession _scan;
  final String taskId;
  late final StreamSubscription<TagScanState> _scanSubscription;

  Future<void> _onTaskRequested(
    MovementScanTaskRequested event,
    Emitter<MovementScanState> emit,
  ) async {
    emit(state.copyWith(task: const LoadInProgress<MovementTask>()));
    final result = await _repository.getTask(taskId);
    emit(
      state.copyWith(
        task: switch (result) {
          Success(:final value) => LoadSuccess(value),
          Failed(:final failure) => LoadFailure(failure),
        },
      ),
    );
  }

  Future<void> _onSubmitted(
    MovementScanSubmitted event,
    Emitter<MovementScanState> emit,
  ) async {
    final task = state.task.valueOrNull;
    if (task == null || !state.canSubmit) return;
    await _scan.stop();
    emit(state.copyWith(submitStatus: SubmitStatus.submitting));
    final result = await _repository.moveForTask(
      movementId: task.movementId,
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
