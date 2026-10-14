import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/confirm_dialog.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';

class FinishInventoryButton extends StatelessWidget {
  const FinishInventoryButton({super.key, required this.state});

  final InventoryScanState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = state.reconciliation;
    final isSubmitting = state.submitStatus.isSubmitting;

    return FilledButton.icon(
      onPressed: isSubmitting || state.isLoadingPlan
          ? null
          : () => confirmThen(
                context,
                title: l10n.inventoryFinishTitle,
                message: l10n.inventoryFinishMessage(
                  result.found.length,
                  result.expectedCount,
                  result.extraEpcs.length,
                ),
                confirmLabel: l10n.inventoryFinish,
                onConfirmed: () => context
                    .read<InventoryScanBloc>()
                    .add(const InventoryScanFinishConfirmed()),
              ),
      icon: isSubmitting
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.cloud_upload_outlined),
      label: Text(l10n.inventoryFinish),
    );
  }
}
