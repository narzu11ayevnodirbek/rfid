import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/app_snackbar.dart';
import 'package:rfid/core/widgets/info_banner.dart';
import 'package:rfid/core/widgets/load_state_view.dart';
import 'package:rfid/core/widgets/message_dialog.dart';
import 'package:rfid/core/widgets/scan_control_bar.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_tag_bind_bloc.dart';
import 'package:rfid/features/marking/presentation/widgets/last_read_tag_card.dart';
import 'package:rfid/features/marking/presentation/widgets/marking_item_details.dart';

class MarkingTagBindPage extends StatelessWidget {
  const MarkingTagBindPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<MarkingTagBindBloc>();

    return BlocConsumer<MarkingTagBindBloc, MarkingTagBindState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        switch (state.submitStatus) {
          case SubmitStatus.succeeded:
            context.showSuccessMessage(l10n.markingTagBound);
            context.pop();
          case SubmitStatus.failed:
            showMessageDialog(
              context,
              title: l10n.markingBindFailedTitle,
              tone: StatusTone.danger,
              lines: [
                MessageDialogLine(
                  state.submitFailure?.localizedMessage(l10n) ?? '',
                ),
              ],
            );
          case SubmitStatus.idle || SubmitStatus.submitting:
            break;
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(l10n.markingItemTitle)),
        body: LoadStateView(
          state: state.item,
          onRetry: () => bloc.add(const MarkingTagBindItemRequested()),
          builder: (context, item) => ListView(
            padding: AppSpacing.list,
            children: [
              MarkingItemDetails(item: item, photoPath: state.photoPath),
              if (item.isBound) ...[
                const SizedBox(height: AppSpacing.sm),
                InfoBanner(
                  tone: StatusTone.warning,
                  message: '${l10n.markingItemBound}: ${item.boundEpc}',
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              ScanControlBar(
                scan: state.scan,
                hint: l10n.markingBindHint,
                onToggle: () => bloc.add(const MarkingTagBindScanToggled()),
              ),
              if (state.tagToBind case final epc?) ...[
                const SizedBox(height: AppSpacing.sm),
                LastReadTagCard(epc: epc),
              ],
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: AppSpacing.page,
            child: FilledButton.icon(
              onPressed: state.canSubmit
                  ? () => bloc.add(const MarkingTagBindSubmitted())
                  : null,
              icon: state.submitStatus.isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.link),
              label: Text(l10n.markingBindSubmit),
            ),
          ),
        ),
      ),
    );
  }
}
