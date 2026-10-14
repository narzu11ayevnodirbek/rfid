import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/item_lookup_button.dart';
import 'package:rfid/core/widgets/list_bloc_view.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_list_bloc.dart';
import 'package:rfid/features/inventory/presentation/widgets/inventory_card.dart';

class InventoryListPage extends StatelessWidget {
  const InventoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryListTitle),
        actions: const [ItemLookupButton()],
      ),
      body: ListBlocView<InventoryListBloc, Inventory>(
        emptyMessage: l10n.inventoryListEmpty,
        emptyIcon: Icons.inventory_2_outlined,
        itemBuilder: (context, inventory) =>
            InventoryCard(inventory: inventory),
      ),
    );
  }
}
