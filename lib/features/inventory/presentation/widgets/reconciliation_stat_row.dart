import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/widgets/stat_tile.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';

class ReconciliationStatRow extends StatelessWidget {
  const ReconciliationStatRow({super.key, required this.state});

  final InventoryScanState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = state.reconciliation;

    StatTile selectable(
      ReconciliationList list,
      String label,
      int value,
      StatusTone tone,
    ) {
      return StatTile(
        label: label,
        value: value,
        tone: tone,
        isSelected: state.selectedList == list,
        onTap: () => context
            .read<InventoryScanBloc>()
            .add(InventoryScanListSelected(list)),
      );
    }

    return StatTileRow(
      tiles: [
        StatTile(label: l10n.statTotal, value: result.expectedCount),
        selectable(
          ReconciliationList.found,
          l10n.statFound,
          result.found.length,
          StatusTone.success,
        ),
        selectable(
          ReconciliationList.missing,
          l10n.statMissing,
          result.missing.length,
          StatusTone.danger,
        ),
        selectable(
          ReconciliationList.extra,
          l10n.statExtra,
          result.extraEpcs.length,
          StatusTone.warning,
        ),
      ],
    );
  }
}
