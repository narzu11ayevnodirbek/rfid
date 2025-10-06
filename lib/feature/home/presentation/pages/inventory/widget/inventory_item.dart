import 'package:flutter/material.dart';
import 'package:rf_id_test/core/extention/extension.dart';
import 'package:rf_id_test/feature/components/titled_status.dart';
import 'package:rf_id_test/feature/components/titled_text.dart';
import 'package:rf_id_test/feature/home/domain/entity/inventory/inventory.dart';

final BorderRadius _borderRadius = 12.kBorderRadiusAll;
final EdgeInsets _padding = 16.kPaddingAll;

class InventoryItem extends StatelessWidget {
  const InventoryItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  final Inventory item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: _borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: _borderRadius,
          child: Ink(
            padding: _padding,
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TitledText(
                              title: 'Название',
                              subTitle: item.name,
                            ),
                          ),
                          12.kBoxWidth,
                          Expanded(
                            child: TitledText(
                              title: 'Тип',
                              subTitle: item.type,
                            ),
                          ),
                        ],
                      ),
                      8.kBoxHeight,
                      Row(
                        children: [
                          Expanded(
                            child: TitledText(
                              title: 'Создан',
                              subTitle: item.createdAt,
                            ),
                          ),
                          12.kBoxWidth,
                          Expanded(
                            child: TitledStatus(
                              status: item.status,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                      } else if (value == 'delete') {}
                    },
                    borderRadius: _borderRadius,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Редактировать'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20),
                            SizedBox(width: 8),
                            Text('Удалить'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
