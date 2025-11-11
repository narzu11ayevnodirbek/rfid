import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rf_id_test/core/extention/extension.dart';
import 'package:rf_id_test/feature/components/titled_status.dart';
import 'package:rf_id_test/feature/components/titled_text.dart';
import 'package:rf_id_test/feature/home/domain/entity/products/products.dart';

final BorderRadius _borderRadius = 12.kBorderRadiusAll;
final EdgeInsets _padding = 16.kPaddingAll;

class ProductsItem extends StatelessWidget {
  const ProductsItem({super.key, required this.item});

  final Products item;

  @override
  Widget build(BuildContext context) {
    final formattedPrice =
        NumberFormat.currency(locale: 'ru_RU', symbol: 'сум', decimalDigits: 0)
            .format(double.tryParse(item.price.toString()) ?? 0);
    return Material(
      child: InkWell(
        onTap: () {},
        borderRadius: _borderRadius,
        child: Ink(
          padding: _padding,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
          ),
          child: Column(
            children: [
              const Placeholder(
                fallbackWidth: double.infinity,
                fallbackHeight: 100,
              ),
              8.kBoxHeight,
              Row(
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
                                title: 'Имеет RFID',
                                subTitle: item.hasRfid == '1' ? 'Есть' : 'Нет',
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
                                subTitle: item.createdAt.toString(),
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
                        12.kBoxHeight,
                        Row(
                          children: [
                            Expanded(
                              child: TitledText(
                                  title: 'Цена', subTitle: formattedPrice),
                            )
                          ],
                        )
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
            ],
          ),
        ),
      ),
    );
  }
}
