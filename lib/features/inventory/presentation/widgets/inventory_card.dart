import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/widgets/labeled_progress_bar.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/features/inventory/domain/entities/inventory.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({super.key, required this.inventory});

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListCard(
      title: l10n.inventoryNumber(inventory.name),
      subtitle: inventory.responsibleName,
      details: [
        if (inventory.type.isNotEmpty) l10n.inventoryType(inventory.type),
        if (inventory.createdAt.isNotEmpty)
          l10n.commonCreatedAt(inventory.createdAt),
      ],
      footer: LabeledProgressBar(
        done: inventory.foundCount,
        total: inventory.totalCount,
      ),
      onTap: () => context.push(AppRoutes.inventoryDetails(inventory.id)),
    );
  }
}
