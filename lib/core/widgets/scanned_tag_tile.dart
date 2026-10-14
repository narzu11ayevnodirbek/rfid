import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';

class ScannedTagTile extends StatelessWidget {
  const ScannedTagTile({
    super.key,
    required this.epc,
    this.title,
    this.tone = StatusTone.neutral,
    this.onRemove,
  });

  final String epc;

  final String? title;
  final StatusTone tone;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.statusColors;
    final epcStyle = theme.textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colors.background(tone),
              child: Icon(
                Icons.sell_outlined,
                size: 16,
                color: colors.foreground(tone),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null && title!.isNotEmpty)
                    Text(title!, style: theme.textTheme.bodyLarge),
                  Text(epc, style: epcStyle),
                ],
              ),
            ),
            if (onRemove != null)
              IconButton(
                tooltip: context.l10n.commonRemove,
                onPressed: onRemove,
                icon: const Icon(Icons.close),
              ),
          ],
        ),
      ),
    );
  }
}
