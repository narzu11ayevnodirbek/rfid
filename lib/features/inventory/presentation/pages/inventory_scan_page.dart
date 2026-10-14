import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/app_snackbar.dart';
import 'package:rfid/core/widgets/message_dialog.dart';
import 'package:rfid/core/widgets/scan_control_bar.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';
import 'package:rfid/features/inventory/presentation/widgets/finish_inventory_button.dart';
import 'package:rfid/features/inventory/presentation/widgets/inventory_plan_banner.dart';
import 'package:rfid/features/inventory/presentation/widgets/reconciliation_item_list.dart';
import 'package:rfid/features/inventory/presentation/widgets/reconciliation_stat_row.dart';

class InventoryScanPage extends StatelessWidget {
  const InventoryScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<InventoryScanBloc, InventoryScanState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus ||
          previous.restoredDraftCount != current.restoredDraftCount,
      listener: (context, state) {
        if (state.restoredDraftCount > 0 &&
            state.submitStatus == SubmitStatus.idle) {
          context.showInfoMessage(
            l10n.inventoryDraftRestored(state.restoredDraftCount),
          );
        }
        switch (state.submitStatus) {
          case SubmitStatus.succeeded:
            context.showSuccessMessage(l10n.inventoryFinished);
            context.pop();
          case SubmitStatus.failed:
            showMessageDialog(
              context,
              title: l10n.inventoryFinishTitle,
              tone: StatusTone.danger,
              lines: [
                MessageDialogLine(
                  state.submitFailure?.localizedMessage(l10n) ?? '',
                  tone: StatusTone.danger,
                ),
                MessageDialogLine(l10n.inventoryFinishFailed),
              ],
            );
          case SubmitStatus.idle || SubmitStatus.submitting:
            break;
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.inventoryNumber(state.title)),
          bottom: state.isLoadingPlan
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InventoryPlanBanner(state: state),
                  ReconciliationStatRow(state: state),
                  const SizedBox(height: AppSpacing.sm),
                  ScanControlBar(
                    scan: state.scan,
                    onToggle: () => context
                        .read<InventoryScanBloc>()
                        .add(const InventoryScanToggled()),
                  ),
                ],
              ),
            ),
            Expanded(child: ReconciliationItemList(state: state)),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: AppSpacing.page,
            child: FinishInventoryButton(state: state),
          ),
        ),
      ),
    );
  }
}
