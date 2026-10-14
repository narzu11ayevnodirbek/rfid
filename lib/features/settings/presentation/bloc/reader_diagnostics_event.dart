part of 'reader_diagnostics_bloc.dart';

sealed class ReaderDiagnosticsEvent {
  const ReaderDiagnosticsEvent();
}

final class ReaderDiagnosticsStarted extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsStarted();
}

final class ReaderDiagnosticsModuleCheckRequested
    extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsModuleCheckRequested();
}

final class ReaderDiagnosticsPowerSelected extends ReaderDiagnosticsEvent {
  const ReaderDiagnosticsPowerSelected(this.dbm);

  final int dbm;
}

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
