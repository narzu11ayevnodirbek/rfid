import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';

/// "12 of 40" with a bar under it. Turns green when everything is done.
class LabeledProgressBar extends StatelessWidget {
  const LabeledProgressBar({
    super.key,
    required this.done,
    required this.total,
  });

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final isComplete = total > 0 && done >= total;
    final colors = context.statusColors;
    final color = isComplete
        ? colors.foreground(StatusTone.success)
        : Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.commonProgress(done, total),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : (done / total).clamp(0, 1),
            color: color,
          ),
        ),
      ],
    );
  }
}
