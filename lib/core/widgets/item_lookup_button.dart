import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';

/// App bar action that opens "find item by tag". Shown on every tab.
class ItemLookupButton extends StatelessWidget {
  const ItemLookupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.commonSearchByTag,
      icon: const Icon(Icons.manage_search),
      onPressed: () => context.push(AppRoutes.itemLookup),
    );
  }
}
