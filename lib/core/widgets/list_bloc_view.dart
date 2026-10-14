import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/bloc/list_bloc.dart';
import 'package:rfid/core/bloc/load_state.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/app_snackbar.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/load_state_view.dart';

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
    return BlocConsumer<B, LoadState<List<T>>>(
      listenWhen: (previous, current) =>
          current is LoadSuccess<List<T>> &&
          current.refreshFailure != null &&
          previous != current,
      listener: (context, state) =>
          context.showErrorMessage(context.l10n.commonRefreshFailed),
      builder: (context, state) => LoadStateView<List<T>>(
        state: state,
        onRetry: () => context.read<B>().add(const ListLoadRequested()),
        builder: (context, items) => RefreshIndicator(
          onRefresh: context.read<B>().refresh,
          child: _buildList(context, items),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<T> items) {
    final headerWidgets = [
      if (header != null) ...[
        header!,
        const SizedBox(height: AppSpacing.md),
      ],
    ];

    if (items.isEmpty) {
      // Still scrollable, so pull-to-refresh works on an empty list.
      return ListView(
        padding: AppSpacing.list,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ...headerWidgets,
          const SizedBox(height: AppSpacing.xxl),
          EmptyStateView(message: emptyMessage, icon: emptyIcon),
        ],
      );
    }

    return ListView(
      padding: AppSpacing.list,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        ...headerWidgets,
        for (final (index, item) in items.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          itemBuilder(context, item),
        ],
      ],
    );
  }
}
