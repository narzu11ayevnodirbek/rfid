import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/load_bloc_view.dart';
import 'package:rfid/core/widgets/stat_tile.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_task_items_bloc.dart';
import 'package:rfid/features/marking/presentation/widgets/marking_item_card.dart';

/// Items of a marking task: which ones still need a tag.
class MarkingTaskItemsPage extends StatelessWidget {
  const MarkingTaskItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = context.select(
      (MarkingTaskItemsBloc bloc) =>
          bloc.state.valueOrNull?.name ?? l10n.markingTasksTitle,
    );

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: LoadBlocView<MarkingTaskItemsBloc, MarkingTask>(
        builder: (context, task) => ListView(
          padding: AppSpacing.list,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            StatTileRow(
              tiles: [
                StatTile(label: l10n.statTotal, value: task.totalCount),
                StatTile(
                  label: l10n.statBound,
                  value: task.boundCount,
                  tone: StatusTone.success,
                ),
                StatTile(
                  label: l10n.statUnbound,
                  value: task.totalCount - task.boundCount,
                  tone: StatusTone.danger,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (task.items.isEmpty)
              EmptyStateView(message: l10n.markingItemsEmpty),
            for (final item in task.items) ...[
              MarkingItemCard(
                item: item,
                onTap: () => context.push(
                  AppRoutes.markingTagBind(task.markingId, task.id, item.id),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
