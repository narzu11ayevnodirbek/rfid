import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/stat_tile.dart';
import 'package:rfid/core/widgets/status_badge.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';

/// Header of the inventory details: status, type, date and counters.
class InventorySummaryCard extends StatelessWidget {
  const InventorySummaryCard({super.key, required this.inventory});

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (inventory.statusLabel.isNotEmpty) ...[
              StatusBadge(label: inventory.statusLabel, tone: StatusTone.info),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (inventory.responsibleName.isNotEmpty)
              Text(
                inventory.responsibleName,
                style: theme.textTheme.titleMedium,
              ),
            if (inventory.type.isNotEmpty)
              Text(l10n.inventoryType(inventory.type), style: muted),
            if (inventory.createdAt.isNotEmpty)
              Text(l10n.commonCreatedAt(inventory.createdAt), style: muted),
            const SizedBox(height: AppSpacing.md),
            StatTileRow(
              tiles: [
                StatTile(label: l10n.statTotal, value: inventory.totalCount),
                StatTile(
                  label: l10n.statFound,
                  value: inventory.foundCount,
                  tone: StatusTone.success,
                ),
                StatTile(
                  label: l10n.statMissing,
                  value: inventory.missingCount,
                  tone: StatusTone.danger,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
