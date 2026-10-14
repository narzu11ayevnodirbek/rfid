import 'package:flutter/material.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';

/// An item of a marking task. Items that already have a tag are not
/// tappable.
class MarkingItemCard extends StatelessWidget {
  const MarkingItemCard({super.key, required this.item, this.onTap});

  final MarkingItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.statusColors;
    final tone = item.isBound ? StatusTone.success : StatusTone.danger;
    return ListCard(
      leading: CircleAvatar(
        backgroundColor: colors.background(tone),
        child: Icon(
          item.isBound ? Icons.check : Icons.sell_outlined,
          color: colors.foreground(tone),
        ),
      ),
      title: item.name,
      subtitle: item.inventoryNumber,
      details: [if (item.isBound) item.boundEpc],
      onTap: item.isBound ? null : onTap,
    );
  }
}
