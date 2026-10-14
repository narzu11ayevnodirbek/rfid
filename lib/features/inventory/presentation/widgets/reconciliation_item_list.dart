import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/scanned_tag_tile.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';

/// The items of the selected counter: missing, found or extra.
class ReconciliationItemList extends StatelessWidget {
  const ReconciliationItemList({super.key, required this.state});

  final InventoryScanState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = state.reconciliation;

    final List<Widget> tiles = switch (state.selectedList) {
      ReconciliationList.missing => [
          for (final item in result.missing)
            ScannedTagTile(
              epc: item.epc,
              title: item.name,
              tone: StatusTone.danger,
            ),
        ],
      ReconciliationList.found => [
          for (final item in result.found.reversed)
            ScannedTagTile(
              epc: item.epc,
              title: item.name,
              tone: StatusTone.success,
            ),
        ],
      ReconciliationList.extra => [
          for (final epc in result.extraEpcs.reversed)
            ScannedTagTile(
              epc: epc,
              tone: StatusTone.warning,
              onRemove: () => context
                  .read<InventoryScanBloc>()
                  .add(InventoryScanExtraTagRemoved(epc)),
            ),
        ],
    };

    if (tiles.isEmpty) {
      return EmptyStateView(
        icon: Icons.checklist,
        message: switch (state.selectedList) {
          ReconciliationList.missing => l10n.inventoryNothingMissing,
          ReconciliationList.found => l10n.inventoryNothingFound,
          ReconciliationList.extra => l10n.inventoryNoExtra,
        },
      );
    }

    return ListView.separated(
      padding: AppSpacing.list,
      itemCount: tiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, index) => tiles[index],
    );
  }
}
