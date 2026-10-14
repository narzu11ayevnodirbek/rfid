import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/labeled_value.dart';
import 'package:rfid/core/widgets/load_state_view.dart';
import 'package:rfid/core/widgets/scan_control_bar.dart';
import 'package:rfid/core/widgets/unsaved_scan_guard.dart';
import 'package:rfid/features/movement/presentation/bloc/movement_scan_bloc.dart';
import 'package:rfid/features/movement/presentation/widgets/scanned_tags_section.dart';
import 'package:rfid/features/movement/presentation/widgets/transfer_dialogs.dart';

/// Collect the items of a movement task and send them.
class MovementScanPage extends StatelessWidget {
  const MovementScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<MovementScanBloc>();

    return BlocConsumer<MovementScanBloc, MovementScanState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) async {
        switch (state.submitStatus) {
          case SubmitStatus.succeeded:
            await showTransferResultDialog(context, state.result!);
            if (context.mounted) context.pop();
          case SubmitStatus.failed:
            await showTransferFailedDialog(context, state.submitFailure!);
          case SubmitStatus.idle || SubmitStatus.submitting:
            break;
        }
      },
      builder: (context, state) => UnsavedScanGuard(
        hasUnsentTags: state.scan.hasTags,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              state.task.valueOrNull?.name ?? l10n.movementListTitle,
            ),
          ),
          body: LoadStateView(
            state: state.task,
            onRetry: () => bloc.add(const MovementScanTaskRequested()),
            builder: (context, task) => ListView(
              padding: AppSpacing.list,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (task.sourceLocation.isNotEmpty)
                          LabeledValue(
                            label: l10n.movementFrom,
                            value: task.sourceLocation,
                          ),
                        LabeledValue(
                          label: l10n.movementTo,
                          value: task.destination,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ScanControlBar(
                  scan: state.scan,
                  onToggle: () => bloc.add(const MovementScanToggled()),
                  onClear: () => bloc.add(const MovementScanTagsCleared()),
                ),
                ScannedTagsSection(
                  tags: state.scan.tags,
                  onRemove: (epc) => bloc.add(MovementScanTagRemoved(epc)),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: AppSpacing.page,
              child: FilledButton.icon(
                onPressed: state.canSubmit
                    ? () => bloc.add(const MovementScanSubmitted())
                    : null,
                icon: state.submitStatus.isSubmitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(l10n.movementSubmit),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
