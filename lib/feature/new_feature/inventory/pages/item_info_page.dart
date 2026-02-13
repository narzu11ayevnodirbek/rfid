import 'package:flutter/material.dart';
import 'package:rf_id_test/core/extention/extension.dart';
import 'package:rf_id_test/feature/new_feature/inventory/models/tag_model.dart';

class ItemInfoPage extends StatelessWidget {
  const ItemInfoPage({super.key, required this.item});

  final TagModel item;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name ?? '-'),
                  containerWidget('MOL'),
                  Text(item.responsible ?? '-'),
                  containerWidget('Держатель'),
                  Text(item.location ?? '-'),
                  containerWidget('Местоположение'),
                  Text(item.statusFilter ?? '-'),
                  containerWidget('Статус'),
                  Text(item.price ?? '-'),
                  containerWidget('Цена'),
                  Text(item.createdAt.fromApiDateTime),
                  containerWidget('Дата постановки на баланс'),
                  Text(item.code ?? '-'),
                  containerWidget('Штрихкод'),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style:
                            FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('ОТМЕНА')),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget containerWidget(String text) => Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        color: Colors.black,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
