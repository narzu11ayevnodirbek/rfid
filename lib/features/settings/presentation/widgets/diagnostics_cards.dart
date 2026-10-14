import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/rfid/rfid_scan_settings.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/status_badge.dart';
import 'package:rfid/features/settings/presentation/bloc/reader_diagnostics_bloc.dart';

/// Whether the RFID module powers on.
class ModuleStatusCard extends StatelessWidget {
  const ModuleStatusCard({super.key, required this.state});

  final ReaderDiagnosticsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final failure = state.moduleFailure;
    final (tone, label) = switch (state.moduleStatus) {
      ModuleStatus.ready => (StatusTone.success, l10n.diagnosticsModuleReady),
      ModuleStatus.failed => (
          StatusTone.danger,
          l10n.diagnosticsModuleNotReady
        ),
      ModuleStatus.unknown || ModuleStatus.checking => (
          StatusTone.neutral,
          l10n.diagnosticsModuleNotReady
        ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.diagnosticsModule,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (state.moduleStatus == ModuleStatus.checking)
                  const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  StatusBadge(label: label, tone: tone),
              ],
            ),
            if (failure != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                failure.localizedMessage(l10n),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.statusColors.foreground(StatusTone.danger),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: state.moduleStatus == ModuleStatus.checking
                  ? null
                  : () => context
                      .read<ReaderDiagnosticsBloc>()
                      .add(const ReaderDiagnosticsModuleCheckRequested()),
              child: Text(l10n.diagnosticsCheckModule),
            ),
          ],
        ),
      ),
    );
  }
}

/// Radio power slider.
class PowerCard extends StatelessWidget {
  const PowerCard({super.key, required this.state});

  final ReaderDiagnosticsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final bloc = context.read<ReaderDiagnosticsBloc>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.diagnosticsPower(state.powerDbm),
              style: theme.textTheme.titleMedium,
            ),
            Slider(
              value: state.powerDbm.toDouble(),
              min: RfidScanSettings.minPowerDbm.toDouble(),
              max: RfidScanSettings.maxPowerDbm.toDouble(),
              divisions:
                  RfidScanSettings.maxPowerDbm - RfidScanSettings.minPowerDbm,
              label: '${state.powerDbm}',
              onChanged: (value) =>
                  bloc.add(ReaderDiagnosticsPowerSelected(value.round())),
              onChangeEnd: (_) =>
                  bloc.add(const ReaderDiagnosticsPowerApplied()),
            ),
            if (state.isPowerAccepted == false)
              Text(
                l10n.diagnosticsPowerRejected,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.statusColors.foreground(StatusTone.warning),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Key code of the last hardware key, to set up the trigger on a new model.
class HardwareKeyCard extends StatelessWidget {
  const HardwareKeyCard({super.key, required this.state});

  final ReaderDiagnosticsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final keyCode = state.lastKeyCode;

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.keyboard_alt_outlined,
          color: state.isKeyDown
              ? context.statusColors.foreground(StatusTone.success)
              : null,
        ),
        title: Text(
          keyCode == null
              ? l10n.diagnosticsNoKey
              : l10n.diagnosticsLastKey(keyCode),
        ),
      ),
    );
  }
}
