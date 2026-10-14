import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/rfid/tag_scan_state.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/confirm_dialog.dart';

/// Reader status, tag counter and the Start/Stop (and optional Clear)
/// buttons. Every scan screen uses this, so the reader always looks and
/// behaves the same way.
class ScanControlBar extends StatelessWidget {
  const ScanControlBar({
    super.key,
    required this.scan,
    required this.onToggle,
    this.onClear,
    this.hint,
  });

  final TagScanState scan;
  final VoidCallback onToggle;

  /// Shows a Clear button (asks for confirmation first) when set.
  final VoidCallback? onClear;

  /// Replaces the default hint shown while the reader is off.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = context.statusColors;
    final failure = scan.failure;

    final (statusTone, statusText) = switch (scan) {
      TagScanState(isReading: true) => (
          StatusTone.success,
          l10n.scanStatusReading
        ),
      TagScanState(isScanning: true) => (StatusTone.info, l10n.scanStatusArmed),
      _ => (StatusTone.neutral, l10n.scanStatusIdle),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: colors.foreground(statusTone),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(statusText, style: theme.textTheme.titleSmall),
                ),
                Text(
                  l10n.scanTagCount(scan.tags.length),
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
            if (failure != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                failure.localizedMessage(l10n),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.foreground(StatusTone.danger),
                ),
              ),
            ] else if (!scan.isScanning) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                hint ?? l10n.scanHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: scan.isBusy ? null : onToggle,
                    icon: scan.isBusy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(scan.isScanning ? Icons.stop : Icons.sensors),
                    label:
                        Text(scan.isScanning ? l10n.scanStop : l10n.scanStart),
                  ),
                ),
                if (onClear != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  OutlinedButton(
                    onPressed: scan.hasTags
                        ? () => confirmThen(
                              context,
                              title: l10n.scanClearTitle,
                              message: l10n.scanClearMessage,
                              confirmLabel: l10n.scanClear,
                              isDestructive: true,
                              onConfirmed: onClear!,
                            )
                        : null,
                    child: Text(l10n.scanClear),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
