import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/widgets/labeled_progress_bar.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/core/widgets/status_badge.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';

class MarkingTaskCard extends StatelessWidget {
  const MarkingTaskCard({super.key, required this.task});

  final MarkingTask task;

  @override
  Widget build(BuildContext context) {
    return ListCard(
      title: task.name,
      subtitle: task.executorName,
      trailing: task.status.isEmpty ? null : StatusBadge(label: task.status),
      footer: LabeledProgressBar(
        done: task.boundCount,
        total: task.totalCount,
      ),
      onTap: () =>
          context.push(AppRoutes.markingTaskItems(task.markingId, task.id)),
    );
  }
}
