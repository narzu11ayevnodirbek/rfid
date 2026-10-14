import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/scan_control_bar.dart';
import 'package:rfid/core/widgets/scanned_tag_tile.dart';
import 'package:rfid/features/settings/presentation/bloc/reader_diagnostics_bloc.dart';
import 'package:rfid/features/settings/presentation/widgets/diagnostics_cards.dart';

class ReaderDiagnosticsPage extends StatelessWidget {
  const ReaderDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ReaderDiagnosticsBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.diagnosticsTitle)),
      body: BlocBuilder<ReaderDiagnosticsBloc, ReaderDiagnosticsState>(
        builder: (context, state) => ListView(
          padding: AppSpacing.list,
          children: [
            ModuleStatusCard(state: state),
            const SizedBox(height: AppSpacing.sm),
            PowerCard(state: state),
            const SizedBox(height: AppSpacing.sm),
            HardwareKeyCard(state: state),
            const SizedBox(height: AppSpacing.sm),
            ScanControlBar(
              scan: state.scan,
              onToggle: () => bloc.add(const ReaderDiagnosticsScanToggled()),
              onClear: () => bloc.add(const ReaderDiagnosticsTagsCleared()),
            ),
            for (final epc in state.scan.tags.reversed) ...[
              const SizedBox(height: AppSpacing.sm),
              ScannedTagTile(epc: epc),
            ],
          ],
        ),
      ),
    );
  }
}
