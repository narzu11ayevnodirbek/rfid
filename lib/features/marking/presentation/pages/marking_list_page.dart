import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/item_lookup_button.dart';
import 'package:rfid/core/widgets/list_bloc_view.dart';
import 'package:rfid/features/marking/domain/entities/marking.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_list_bloc.dart';
import 'package:rfid/features/marking/presentation/widgets/marking_card.dart';

class MarkingListPage extends StatelessWidget {
  const MarkingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.markingListTitle),
        actions: const [ItemLookupButton()],
      ),
      body: ListBlocView<MarkingListBloc, Marking>(
        emptyMessage: l10n.markingListEmpty,
        emptyIcon: Icons.sell_outlined,
        itemBuilder: (context, marking) => MarkingCard(marking: marking),
      ),
    );
  }
}
