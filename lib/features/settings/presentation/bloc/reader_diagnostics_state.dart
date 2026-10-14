part of 'reader_diagnostics_bloc.dart';

enum ModuleStatus { unknown, checking, ready, failed }

class ReaderDiagnosticsState extends Equatable {
  const ReaderDiagnosticsState({
    required this.powerDbm,
    this.moduleStatus = ModuleStatus.unknown,
    this.moduleFailure,
    this.isPowerAccepted,
    this.scan = const TagScanState(),
    this.lastKeyCode,
    this.isKeyDown = false,
  });

  final ModuleStatus moduleStatus;
  final Failure? moduleFailure;
  final int powerDbm;

  /// Answer of the reader to the last power change; `null` before the first.
  final bool? isPowerAccepted;
  final TagScanState scan;

  /// Android key code of the last hardware key, to configure the trigger.
  final int? lastKeyCode;
  final bool isKeyDown;

  ReaderDiagnosticsState copyWith({
    ModuleStatus? moduleStatus,
    Failure? moduleFailure,
    int? powerDbm,
    bool? isPowerAccepted,
    TagScanState? scan,
    int? lastKeyCode,
    bool? isKeyDown,
  }) {
    return ReaderDiagnosticsState(
      moduleStatus: moduleStatus ?? this.moduleStatus,
      moduleFailure: (moduleStatus ?? this.moduleStatus) == ModuleStatus.failed
          ? moduleFailure ?? this.moduleFailure
          : null,
      powerDbm: powerDbm ?? this.powerDbm,
      isPowerAccepted: isPowerAccepted ?? this.isPowerAccepted,
      scan: scan ?? this.scan,
      lastKeyCode: lastKeyCode ?? this.lastKeyCode,
      isKeyDown: isKeyDown ?? this.isKeyDown,
    );
  }

  @override
  List<Object?> get props => [
        moduleStatus,
        moduleFailure,
        powerDbm,
        isPowerAccepted,
        scan,
        lastKeyCode,
        isKeyDown,
      ];
}
