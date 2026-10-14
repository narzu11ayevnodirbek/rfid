import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';

/// The tag that will be bound, large enough to check at a glance.
class LastReadTagCard extends StatelessWidget {
  const LastReadTagCard({super.key, required this.epc});

  final String epc;

  @override
  Widget build(BuildContext context) {
    final colors = context.statusColors;
    final theme = Theme.of(context);
    return Card(
      color: colors.background(StatusTone.success),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.markingLastTag,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.foreground(StatusTone.success),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SelectableText(
              epc,
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'monospace',
                color: colors.foreground(StatusTone.success),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
