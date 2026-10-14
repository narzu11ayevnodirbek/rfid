import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/repository_guard.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/rfid/tag_scan_session.dart';
import 'package:rfid/core/rfid/tag_scan_state.dart';

part 'reader_diagnostics_event.dart';
part 'reader_diagnostics_state.dart';

/// Checks the hardware on the device: module power-on, radio power, reading
/// and the key code of the trigger. Meant for setting up a new handheld.
class ReaderDiagnosticsBloc
    extends Bloc<ReaderDiagnosticsEvent, ReaderDiagnosticsState> {
  ReaderDiagnosticsBloc(this._reader, {TagScanSession? scanSession})
      : _scan = scanSession ??
            TagScanSession(
              reader: _reader,
              powerProfile: RfidPowerProfile.diagnostics,
            ),
        super(
          ReaderDiagnosticsState(powerDbm: RfidPowerProfile.diagnostics.dbm),
        ) {
    on<ReaderDiagnosticsStarted>(_onStarted);
    on<ReaderDiagnosticsModuleCheckRequested>(_onModuleCheckRequested);
    on<ReaderDiagnosticsPowerSelected>(
      (event, emit) => emit(state.copyWith(powerDbm: event.dbm)),
    );
    on<ReaderDiagnosticsPowerApplied>(_onPowerApplied);
    on<ReaderDiagnosticsScanToggled>(_onScanToggled);
    on<ReaderDiagnosticsTagsCleared>((event, emit) => _scan.clear());
    on<_ScanStateChanged>(
      (event, emit) => emit(state.copyWith(scan: event.scan)),
    );
    on<_HardwareKeyReceived>(
      (event, emit) => emit(
        state.copyWith(lastKeyCode: event.keyCode, isKeyDown: event.isDown),
      ),
    );

    _scanSubscription =
        _scan.states.listen((scan) => add(_ScanStateChanged(scan)));
    _keySubscription = _reader.events.listen((event) {
      if (event case HardwareKeyPressed(:final keyCode, :final isDown)) {
        add(_HardwareKeyReceived(keyCode: keyCode, isDown: isDown));
      }
    });
  }

  final RfidReader _reader;
  final TagScanSession _scan;
  late final StreamSubscription<TagScanState> _scanSubscription;
  late final StreamSubscription<RfidReaderEvent> _keySubscription;

  Future<void> _onStarted(
    ReaderDiagnosticsStarted event,
    Emitter<ReaderDiagnosticsState> emit,
  ) async {
    await guard(() => _reader.setKeyEventReporting(enabled: true));
    await _onModuleCheckRequested(
      const ReaderDiagnosticsModuleCheckRequested(),
      emit,
    );
  }

  Future<void> _onModuleCheckRequested(
    ReaderDiagnosticsModuleCheckRequested event,
    Emitter<ReaderDiagnosticsState> emit,
  ) async {
    emit(state.copyWith(moduleStatus: ModuleStatus.checking));
    final result = await guard(_reader.initialize);
    switch (result) {
      case Success():
        emit(state.copyWith(moduleStatus: ModuleStatus.ready));
      case Failed(:final failure):
        emit(
          state.copyWith(
            moduleStatus: ModuleStatus.failed,
            moduleFailure: failure,
          ),
        );
    }
  }

  Future<void> _onPowerApplied(
    ReaderDiagnosticsPowerApplied event,
    Emitter<ReaderDiagnosticsState> emit,
  ) async {
    final result = await guard(() => _reader.setPower(state.powerDbm));
    emit(state.copyWith(isPowerAccepted: result.valueOrNull ?? false));
  }

  Future<void> _onScanToggled(
    ReaderDiagnosticsScanToggled event,
    Emitter<ReaderDiagnosticsState> emit,
  ) async {
    await _scan.toggle();
    // The session starts with the profile power; keep the slider's value.
    if (_scan.state.isScanning) {
      await _onPowerApplied(const ReaderDiagnosticsPowerApplied(), emit);
    }
  }

  @override
  Future<void> close() async {
    await _scanSubscription.cancel();
    await _keySubscription.cancel();
    await _scan.dispose();
    await guard(() => _reader.setKeyEventReporting(enabled: false));
    return super.close();
  }
}
