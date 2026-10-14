import 'package:flutter/material.dart';
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
      trailing: task.status.isEmpty ? null : StatusBadge(label: task.status),
      footer: LabeledProgressBar(
        done: task.foundCount,
        total: task.totalCount,
      ),
    );
  }
}
