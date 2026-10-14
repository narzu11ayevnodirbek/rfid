import 'package:flutter/material.dart';
import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/load_bloc_view.dart';

/// The body of every list screen backed by a [ListBloc]: loading, error with
/// retry, empty message, pull-to-refresh and the cards themselves.
///
/// A list page only describes one card:
///
/// ```dart
/// ListBlocView<InventoryListBloc, Inventory>(
///   emptyMessage: l10n.inventoryListEmpty,
///   itemBuilder: (context, inventory) => InventoryCard(inventory: inventory),
/// )
/// ```
class ListBlocView<B extends ListBloc<T>, T> extends StatelessWidget {
  const ListBlocView({
    super.key,
    required this.itemBuilder,
    required this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.header,
  });

  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;
  final IconData emptyIcon;

  /// Shown above the cards, scrolling with them.
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return LoadBlocView<B, List<T>>(
      builder: (context, items) => ListView(
        padding: AppSpacing.list,
        // Scrollable even when short, so pull-to-refresh always works.
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (header != null) ...[
            header!,
            const SizedBox(height: AppSpacing.md),
          ],
          if (items.isEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            EmptyStateView(message: emptyMessage, icon: emptyIcon),
          ],
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            itemBuilder(context, item),
          ],
        ],
      ),
    );
  }
}
