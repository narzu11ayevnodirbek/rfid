import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/widgets/list_card.dart';

class FreeTransferEntryCard extends StatelessWidget {
  const FreeTransferEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return ListCard(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        child: Icon(Icons.open_with, color: scheme.onPrimaryContainer),
      ),
      title: l10n.movementFreeTransferTitle,
      subtitle: l10n.movementFreeTransferSubtitle,
      onTap: () => context.push(AppRoutes.freeTransfer),
    );
  }
}
