import 'package:flutter/material.dart';
import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/load_bloc_view.dart';

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
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return LoadBlocView<B, List<T>>(
      builder: (context, items) {
        final leading = [
          if (header != null) header!,
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxl),
              child: EmptyStateView(message: emptyMessage, icon: emptyIcon),
            ),
        ];
        return ListView.separated(
          padding: AppSpacing.list,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: leading.length + items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => index < leading.length
              ? leading[index]
              : itemBuilder(context, items[index - leading.length]),
        );
      },
    );
  }
}
