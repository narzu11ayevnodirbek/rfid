import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/item_photo.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/features/item_lookup/domain/entities/catalog_item.dart';

/// A catalogue item found by its tag.
class CatalogItemCard extends StatelessWidget {
  const CatalogItemCard({super.key, required this.item});

  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListCard(
      leading: SizedBox.square(
        dimension: 56,
        child: ItemPhoto(path: item.photoPath, height: 56),
      ),
      title: item.name,
      subtitle: item.code,
      details: [
        if (item.location.isNotEmpty) l10n.itemLocation(item.location),
        if (item.responsible.isNotEmpty) l10n.itemResponsible(item.responsible),
        item.epc,
      ],
    );
  }
}
