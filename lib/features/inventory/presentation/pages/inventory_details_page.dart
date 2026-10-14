import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/load_bloc_view.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_details.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_details_bloc.dart';
import 'package:rfid/features/inventory/presentation/widgets/inventory_summary_card.dart';
import 'package:rfid/features/inventory/presentation/widgets/inventory_task_card.dart';

/// An inventory, the progress of its tasks and the "start scanning" button.
class InventoryDetailsPage extends StatelessWidget {
  const InventoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inventoryId = context.read<InventoryDetailsBloc>().inventoryId;
    final title = context.select(
      (InventoryDetailsBloc bloc) =>
          bloc.state.valueOrNull?.inventory.name ?? inventoryId,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventoryNumber(title))),
      body: LoadBlocView<InventoryDetailsBloc, InventoryDetails>(
        builder: (context, details) => ListView(
          padding: AppSpacing.list,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            InventorySummaryCard(inventory: details.inventory),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.inventoryTasksTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (details.tasks.isEmpty)
              EmptyStateView(message: l10n.inventoryTasksEmpty),
            for (final task in details.tasks) ...[
              InventoryTaskCard(task: task),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.page,
          child: FilledButton.icon(
            icon: const Icon(Icons.sensors),
            label: Text(l10n.inventoryStartScan),
            onPressed: () => context.push(AppRoutes.inventoryScan(inventoryId)),
          ),
        ),
      ),
    );
  }
}
