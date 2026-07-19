import 'package:flutter/material.dart';
import 'package:rfid/core/extension/extension.dart';

import 'package:rfid/feature/new_feature/inventory/models/tag_model.dart';

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
                  _sectionTitle('Наименование'),
                  _valueText(item.name),
                  const SizedBox(height: 12),
                  _sectionTitle('Местоположение'),
                  _valueText(item.location),
                  const SizedBox(height: 12),
                  _sectionTitle('Ответственный'),
                  _valueText(item.responsible),
                  const SizedBox(height: 12),
                  _sectionTitle('RFID (EPC)'),
                  _valueText(item.rfid),
                  const SizedBox(height: 12),
                  _sectionTitle('Штрихкод'),
                  _valueText(item.code),
                  const SizedBox(height: 12),
                  _sectionTitle('Статус'),
                  _valueText(item.statusFilter),
                  const SizedBox(height: 12),
                  _sectionTitle('Цена'),
                  _valueText(item.price),
                  const SizedBox(height: 12),
                  _sectionTitle('Дата постановки на баланс'),
                  _valueText(item.createdAt.fromApiDateTime),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Закрыть')),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  Widget _valueText(String? text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          (text == null || text.isEmpty) ? '-' : text,
          style: const TextStyle(fontSize: 14),
        ),
      );
}
