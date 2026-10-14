import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/info_banner.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';

class InventoryPlanBanner extends StatelessWidget {
  const InventoryPlanBanner({super.key, required this.state});

  final InventoryScanState state;

  @override
  Widget build(BuildContext context) {
    final banner = _buildBanner(context);
    if (banner == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: banner,
    );
  }

  Widget? _buildBanner(BuildContext context) {
    final l10n = context.l10n;
    final failure = state.planFailure;

    if (failure != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoBanner(
            tone: StatusTone.warning,
            icon: Icons.cloud_off_outlined,
            message:
                '${failure.localizedMessage(l10n)}\n${l10n.inventoryPlanEmpty}',
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context
                  .read<InventoryScanBloc>()
                  .add(const InventoryScanPlanRequested()),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.commonRetry),
            ),
          ),
        ],
      );
    }
    if (state.isPlanFromCache) {
      return InfoBanner(
        tone: StatusTone.warning,
        icon: Icons.cloud_off_outlined,
        message: l10n.inventoryPlanFromCache,
      );
    }
    if (state.isPlanEmpty) {
      return InfoBanner(message: l10n.inventoryPlanEmpty);
    }
    return null;
  }
}
