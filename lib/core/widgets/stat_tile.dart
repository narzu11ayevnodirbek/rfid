import 'package:flutter/material.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';

/// A number with a label under it ("Found 12").
///
/// When [onTap] is set the tile works like a tab: [isSelected] highlights it.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.tone = StatusTone.neutral,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final int value;
  final StatusTone tone;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.statusColors;
    return Material(
      color: isSelected
          ? colors.background(tone)
          : theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isSelected
              ? colors.foreground(tone)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            children: [
              Text(
                '$value',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.foreground(tone),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              FittedBox(
                // Four tiles share a narrow handheld screen: shrink, never cut.
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [StatTile]s side by side, equal width.
class StatTileRow extends StatelessWidget {
  const StatTileRow({super.key, required this.tiles});

  final List<StatTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(child: tiles[i]),
        ],
      ],
    );
  }
}
