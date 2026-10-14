part of 'reader_diagnostics_bloc.dart';

sealed class ReaderDiagnosticsEvent {
  const ReaderDiagnosticsEvent();
}

/// The screen opened: report hardware keys and check the module.
final class ReaderDiagnosticsStarted extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsStarted();
}

final class ReaderDiagnosticsModuleCheckRequested
    extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsModuleCheckRequested();
}

/// The slider moved. Only the shown value changes.
final class ReaderDiagnosticsPowerSelected extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsPowerSelected(this.dbm);

  final int dbm;
}

/// The slider was released: send the selected power to the reader.
final class ReaderDiagnosticsPowerApplied extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsPowerApplied();
}

final class ReaderDiagnosticsScanToggled extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsScanToggled();
}

final class ReaderDiagnosticsTagsCleared extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsTagsCleared();
}

final class _ScanStateChanged extends ReaderDiagnosticsEvent {
  const _ScanStateChanged(this.scan);

  final TagScanState scan;
}

final class _HardwareKeyReceived extends ReaderDiagnosticsEvent {
  const _HardwareKeyReceived({required this.keyCode, required this.isDown});

  final int keyCode;
  final bool isDown;
}
