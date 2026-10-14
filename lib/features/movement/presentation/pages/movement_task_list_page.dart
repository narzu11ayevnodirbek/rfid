import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/item_lookup_button.dart';
import 'package:rfid/core/widgets/list_bloc_view.dart';
import 'package:rfid/features/movement/domain/entities/movement_task.dart';
import 'package:rfid/features/movement/presentation/bloc/movement_task_list_bloc.dart';
import 'package:rfid/features/movement/presentation/widgets/free_transfer_entry_card.dart';
import 'package:rfid/features/movement/presentation/widgets/movement_task_card.dart';

class MovementTaskListPage extends StatelessWidget {
  const MovementTaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.movementListTitle),
        actions: const [ItemLookupButton()],
      ),
      body: ListBlocView<MovementTaskListBloc, MovementTask>(
        header: const FreeTransferEntryCard(),
        emptyMessage: l10n.movementListEmpty,
        emptyIcon: Icons.swap_horiz,
        itemBuilder: (context, task) => MovementTaskCard(task: task),
      ),
    );
  }
}
