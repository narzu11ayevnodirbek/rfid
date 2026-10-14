import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/info_banner.dart';
import 'package:rfid/core/widgets/load_state_view.dart';
import 'package:rfid/core/widgets/scan_control_bar.dart';
import 'package:rfid/features/item_lookup/presentation/bloc/item_lookup_bloc.dart';
import 'package:rfid/features/item_lookup/presentation/widgets/catalog_item_card.dart';

class ItemLookupPage extends StatelessWidget {
  const ItemLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<ItemLookupBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.itemLookupTitle)),
      body: BlocBuilder<ItemLookupBloc, ItemLookupState>(
        builder: (context, state) => LoadStateView(
          state: state.catalog,
          onRetry: () => bloc.add(const ItemLookupCatalogRequested()),
          builder: (context, _) => ListView(
            padding: AppSpacing.list,
            children: [
              ScanControlBar(
                scan: state.scan,
                onToggle: () => bloc.add(const ItemLookupScanToggled()),
                onClear: () => bloc.add(const ItemLookupCleared()),
              ),
              if (state.unknownTagCount > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                InfoBanner(
                  tone: StatusTone.warning,
                  message: l10n.itemLookupUnknownTags(state.unknownTagCount),
                ),
              ],
              if (state.foundItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxl),
                  child: EmptyStateView(
                    icon: Icons.manage_search,
                    message: l10n.itemLookupEmpty,
                  ),
                ),
              for (final item in state.foundItems) ...[
                const SizedBox(height: AppSpacing.sm),
                CatalogItemCard(item: item),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
