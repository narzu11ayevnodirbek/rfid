import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/empty_state_view.dart';
import 'package:rfid/core/widgets/scanned_tag_tile.dart';

/// Tags collected for a move, newest first, each removable.
class ScannedTagsSection extends StatelessWidget {
  const ScannedTagsSection({
    super.key,
    required this.tags,
    required this.onRemove,
  });

  final List<String> tags;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xl),
        child: EmptyStateView(
          icon: Icons.sell_outlined,
          message: context.l10n.scanNoTags,
        ),
      );
    }
    return Column(
      children: [
        for (final epc in tags.reversed) ...[
          const SizedBox(height: AppSpacing.sm),
          ScannedTagTile(epc: epc, onRemove: () => onRemove(epc)),
        ],
      ],
    );
  }
}
