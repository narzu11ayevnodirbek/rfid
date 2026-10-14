import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/submit_status.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/load_state_view.dart';
import 'package:rfid/core/widgets/scan_control_bar.dart';
import 'package:rfid/core/widgets/unsaved_scan_guard.dart';
import 'package:rfid/features/movement/presentation/bloc/free_transfer_bloc.dart';
import 'package:rfid/features/movement/presentation/widgets/location_picker.dart';
import 'package:rfid/features/movement/presentation/widgets/scanned_tags_section.dart';
import 'package:rfid/features/movement/presentation/widgets/transfer_dialogs.dart';

class FreeTransferPage extends StatelessWidget {
  const FreeTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<FreeTransferBloc>();

    return BlocConsumer<FreeTransferBloc, FreeTransferState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        switch (state.submitStatus) {
          case SubmitStatus.succeeded:
            showTransferResultDialog(context, state.result!);
          case SubmitStatus.failed:
            showTransferFailedDialog(context, state.submitFailure!);
          case SubmitStatus.idle || SubmitStatus.submitting:
            break;
        }
      },
      builder: (context, state) => UnsavedScanGuard(
        hasUnsentTags: state.scan.hasTags,
        child: Scaffold(
          appBar: AppBar(title: Text(l10n.movementFreeTransferTitle)),
          body: LoadStateView(
            state: state.locations,
            onRetry: () => bloc.add(const FreeTransferLocationsRequested()),
            builder: (context, locations) => ListView(
              padding: AppSpacing.list,
              children: [
                LocationPicker(
                  locations: locations,
                  selected: state.selectedLocation,
                  showRequiredError: state.showLocationRequired,
                  onSelected: (location) =>
                      bloc.add(FreeTransferLocationSelected(location)),
                ),
                const SizedBox(height: AppSpacing.md),
                ScanControlBar(
                  scan: state.scan,
                  onToggle: () => bloc.add(const FreeTransferScanToggled()),
                  onClear: () => bloc.add(const FreeTransferTagsCleared()),
                ),
                ScannedTagsSection(
                  tags: state.scan.tags,
                  onRemove: (epc) => bloc.add(FreeTransferTagRemoved(epc)),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: AppSpacing.page,
              child: FilledButton.icon(
                onPressed: state.canSubmit
                    ? () => bloc.add(const FreeTransferSubmitted())
                    : null,
                icon: state.submitStatus.isSubmitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(l10n.movementMove),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
