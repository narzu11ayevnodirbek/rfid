import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/widgets/labeled_progress_bar.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/core/widgets/status_badge.dart';
import 'package:rfid/features/inventory/domain/entities/inventory_task.dart';

class InventoryTaskCard extends StatelessWidget {
  const InventoryTaskCard({super.key, required this.task});

  final InventoryTask task;

  @override
  Widget build(BuildContext context) {
    return ListCard(
      title: task.location,
      subtitle: task.employeeName,
      trailing: task.status.isEmpty ? null : _TaskStatusBadge(task.status),
      footer: LabeledProgressBar(
        done: task.foundCount,
        total: task.totalCount,
      ),
    );
  }
}

class _TaskStatusBadge extends StatelessWidget {
  const _TaskStatusBadge(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // The API sends machine codes; unknown ones are shown as they are.
    final (label, tone) = switch (status) {
      'pending' => (l10n.taskStatusPending, StatusTone.neutral),
      'in_progress' => (l10n.taskStatusInProgress, StatusTone.info),
      'completed' || 'done' => (l10n.taskStatusCompleted, StatusTone.success),
      _ => (status, StatusTone.neutral),
    };
    return StatusBadge(label: label, tone: tone);
  }
}
