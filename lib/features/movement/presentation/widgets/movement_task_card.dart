import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/widgets/labeled_progress_bar.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/core/widgets/status_badge.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';

class MovementTaskCard extends StatelessWidget {
  const MovementTaskCard({super.key, required this.task});

  final MovementTask task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListCard(
      title: task.name,
      subtitle: task.executorName,
      details: [
        if (task.sourceLocation.isNotEmpty)
          '${l10n.movementFrom}: ${task.sourceLocation}',
        if (task.destination.isNotEmpty)
          '${l10n.movementTo}: ${task.destination}',
        if (task.createdAt.isNotEmpty) l10n.commonCreatedAt(task.createdAt),
      ],
      trailing: task.status.isEmpty ? null : StatusBadge(label: task.status),
      footer: task.totalCount == 0
          ? null
          : LabeledProgressBar(done: task.movedCount, total: task.totalCount),
      onTap: () => context.push(AppRoutes.movementScan(task.id)),
    );
  }
}
