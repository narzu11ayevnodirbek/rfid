import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/core/rfid/tag_scan_state.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_plan.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_reconciliation.dart';
import 'package:rfid/features/inventory/domain/repositories/inventory_repository.dart';

part 'inventory_scan_event.dart';
part 'inventory_scan_state.dart';

class InventoryScanBloc extends Bloc<InventoryScanEvent, InventoryScanState> {
  InventoryScanBloc({
    required InventoryRepository repository,
    required RfidReader reader,
    required String inventoryId,
    TagScanSession? scanSession,
    this.draftSaveDelay = const Duration(seconds: 1),
  })  : _repository = repository,
        _scan = scanSession ??
            TagScanSession(
              reader: reader,
              powerProfile: RfidPowerProfile.inventory,
            ),
        super(InventoryScanState(inventoryId: inventoryId)) {
    on<InventoryScanStarted>(_onStarted);
    on<InventoryScanPlanRequested>((event, emit) => _loadPlan(emit));
    on<InventoryScanToggled>(_onToggled);
    on<InventoryScanListSelected>(
      (event, emit) => emit(state.copyWith(selectedList: event.list)),
    );
    on<InventoryScanExtraTagRemoved>((event, emit) => _scan.remove(event.epc));
    on<InventoryScanFinishConfirmed>(_onFinishConfirmed);
    on<_ScanStateChanged>(_onScanStateChanged);

    _scanSubscription =
        _scan.states.listen((scan) => add(_ScanStateChanged(scan)));
  }

  final InventoryRepository _repository;
  final TagScanSession _scan;

  final Duration draftSaveDelay;

  late final StreamSubscription<TagScanState> _scanSubscription;
  Timer? _draftTimer;
  DateTime? _firstScanStartedAt;

  String get _inventoryId => state.inventoryId;

  Future<void> _onStarted(
    InventoryScanStarted event,
    Emitter<InventoryScanState> emit,
  ) async {
    final draft = _repository.readDraft(_inventoryId);
    final restored = draft?.scannedEpcs ?? const <String>[];
    if (restored.isNotEmpty) _scan.restore(restored);
    emit(
      state.copyWith(
        inventoryName: _repository.findInventoryName(_inventoryId),
        restoredDraftCount: restored.length,
      ),
    );
    await _loadPlan(emit);
  }

  Future<void> _loadPlan(Emitter<InventoryScanState> emit) async {
    emit(state.copyWith(isLoadingPlan: true, clearPlanFailure: true));
    final result = await _repository.getPlan(_inventoryId);
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            isLoadingPlan: false,
            plan: value.plan,
            isPlanFromCache: value.isFromCache,
            reconciliation: _reconcile(value.plan, state.scan.tags),
          ),
        );
      case Failed(:final failure):
        final plan = state.plan ?? InventoryPlan.empty(_inventoryId);
        emit(
          state.copyWith(
            isLoadingPlan: false,
            plan: plan,
            planFailure: failure,
            reconciliation: _reconcile(plan, state.scan.tags),
          ),
        );
    }
  }

  Future<void> _onToggled(
    InventoryScanToggled event,
    Emitter<InventoryScanState> emit,
  ) async {
    if (!_scan.state.isScanning) _firstScanStartedAt ??= DateTime.now();
    await _scan.toggle();
  }

  void _onScanStateChanged(
    _ScanStateChanged event,
    Emitter<InventoryScanState> emit,
  ) {
    final tagsChanged = event.scan.tags != state.scan.tags;
    emit(
      state.copyWith(
        scan: event.scan,
        reconciliation:
            tagsChanged ? _reconcile(state.plan, event.scan.tags) : null,
      ),
    );
    if (tagsChanged && state.submitStatus != SubmitStatus.succeeded) {
      _scheduleDraftSave();
    }
  }

  Future<void> _onFinishConfirmed(
    InventoryScanFinishConfirmed event,
    Emitter<InventoryScanState> emit,
  ) async {
    if (state.submitStatus.isSubmitting) return;
    await _scan.stop();
    emit(state.copyWith(submitStatus: SubmitStatus.submitting));

    final startedAt = _firstScanStartedAt;
    final result = await _repository.finishInventory(
      inventoryId: _inventoryId,
      scannedEpcs: state.scan.tags,
      duration: startedAt == null
          ? Duration.zero
          : DateTime.now().difference(startedAt),
    );
    switch (result) {
      case Success():
        _draftTimer?.cancel();
        emit(state.copyWith(submitStatus: SubmitStatus.succeeded));
      case Failed(:final failure):
        await _saveDraftNow();
        emit(
          state.copyWith(
            submitStatus: SubmitStatus.failed,
            submitFailure: failure,
          ),
        );
    }
  }

  InventoryReconciliation _reconcile(InventoryPlan? plan, List<String> tags) =>
      InventoryReconciliation.compute(
        plan: plan ?? InventoryPlan.empty(_inventoryId),
        scannedEpcs: tags,
      );

  void _scheduleDraftSave() {
    _draftTimer?.cancel();
    _draftTimer = Timer(draftSaveDelay, _saveDraftNow);
  }

  Future<void> _saveDraftNow() {
    _draftTimer?.cancel();
    return _repository.saveDraft(_inventoryId, _scan.state.tags);
  }

  @override
  Future<void> close() async {
    // Write the pending draft before the session forgets the tags.
    if (_draftTimer?.isActive ?? false) await _saveDraftNow();
    await _scanSubscription.cancel();
    await _scan.dispose();
    return super.close();
  }
}
