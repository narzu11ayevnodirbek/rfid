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
import 'package:rfid/features/marking/domain/entities/marking_item.dart';
import 'package:rfid/features/marking/domain/repositories/marking_repository.dart';

part 'marking_tag_bind_event.dart';
part 'marking_tag_bind_state.dart';

class MarkingTagBindBloc
    extends Bloc<MarkingTagBindEvent, MarkingTagBindState> {
  MarkingTagBindBloc({
    required MarkingRepository repository,
    required RfidReader reader,
    required this.markingId,
    required this.taskId,
    required this.itemId,
    TagScanSession? scanSession,
  })  : _repository = repository,
        _scan = scanSession ??
            TagScanSession(
              reader: reader,
              powerProfile: RfidPowerProfile.marking,
            ),
        super(const MarkingTagBindState()) {
    on<MarkingTagBindItemRequested>(_onItemRequested);
    on<MarkingTagBindScanToggled>((event, emit) => _scan.toggle());
    on<MarkingTagBindSubmitted>(_onSubmitted);
    on<_ScanStateChanged>(
      (event, emit) => emit(state.copyWith(scan: event.scan)),
    );

    _scanSubscription =
        _scan.states.listen((scan) => add(_ScanStateChanged(scan)));
  }

  final MarkingRepository _repository;
  final TagScanSession _scan;
  final String markingId;
  final String taskId;
  final String itemId;
  late final StreamSubscription<TagScanState> _scanSubscription;

  Future<void> _onItemRequested(
    MarkingTagBindItemRequested event,
    Emitter<MarkingTagBindState> emit,
  ) async {
    emit(state.copyWith(item: const LoadInProgress<MarkingItem>()));
    final (item, photo) = await (
      _repository.getItem(
        markingId: markingId,
        taskId: taskId,
        itemId: itemId,
      ),
      _repository.getItemPhotoPath(markingId: markingId, itemId: itemId),
    ).wait;
    emit(
      state.copyWith(
        item: switch (item) {
          Success(:final value) => LoadSuccess(value),
          Failed(:final failure) => LoadFailure(failure),
        },
        photoPath: photo.valueOrNull ?? item.valueOrNull?.photoPath ?? '',
      ),
    );
  }

  Future<void> _onSubmitted(
    MarkingTagBindSubmitted event,
    Emitter<MarkingTagBindState> emit,
  ) async {
    final epc = state.tagToBind;
    if (epc == null || !state.canSubmit) return;
    await _scan.stop();
    emit(state.copyWith(submitStatus: SubmitStatus.submitting));
    final result = await _repository.bindTag(
      markingId: markingId,
      taskId: taskId,
      itemId: itemId,
      epc: epc,
    );
    switch (result) {
      case Success():
        emit(state.copyWith(submitStatus: SubmitStatus.succeeded));
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
