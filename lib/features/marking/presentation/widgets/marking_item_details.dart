import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/item_photo.dart';
import 'package:rfid/core/widgets/labeled_value.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';

/// Photo and fields of the item that gets a tag.
class MarkingItemDetails extends StatelessWidget {
  const MarkingItemDetails({
    super.key,
    required this.item,
    required this.photoPath,
  });

  final MarkingItem item;
  final String photoPath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ItemPhoto(path: photoPath, height: 180),
            const SizedBox(height: AppSpacing.lg),
            LabeledValue(label: l10n.markingItemName, value: item.name),
            LabeledValue(
              label: l10n.markingItemInventoryNumber,
              value: item.inventoryNumber,
            ),
            LabeledValue(label: l10n.markingItemStatus, value: item.status),
          ],
        ),
      ),
    );
  }
}
