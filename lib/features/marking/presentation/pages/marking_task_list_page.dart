import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/list_bloc_view.dart';
import 'package:rfid/features/marking/domain/entities/marking_task.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_task_list_bloc.dart';
import 'package:rfid/features/marking/presentation/widgets/marking_task_card.dart';

class MarkingTaskListPage extends StatelessWidget {
  const MarkingTaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.markingTasksTitle)),
      body: ListBlocView<MarkingTaskListBloc, MarkingTask>(
        emptyMessage: l10n.markingTasksEmpty,
        itemBuilder: (context, task) => MarkingTaskCard(task: task),
      ),
    );
  }
}
