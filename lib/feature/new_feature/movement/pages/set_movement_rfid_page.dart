import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../inventory/pages/barcode_page.dart';
import '../../rfid/rfid_controller.dart';
import '../models/movement_item.dart';

class SetMovementRfidPage extends StatelessWidget {
  const SetMovementRfidPage({super.key, required this.item});

  final MovementItem item;

  @override
  Widget build(BuildContext context) {
    final rfid = Get.find<RfidController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Единица ТМЦ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title('Наименование'),
                _value(item.name),
                _title('Инвентарный номер'),
                _value(item.movementNumber),
                _title('Статус'),
                _value(item.status),
                _title('Фото'),
                const SizedBox(height: 12),
                Center(
                  child: item.photo.isNotEmpty
                      ? Image.network(item.photo, height: 200)
                      : const Icon(Icons.image_not_supported, size: 120),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 100,
                  child: GestureDetector(
                    onTap: () => Get.to(const BarcodePage()),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black,
                      ),
                      child: Image.asset(
                        'assets/images/barcode.png',
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'Мощность RFID считывателя',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Текущая мощность 100%',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await rfid.initOnce();
                          await rfid.start();

                          Get.snackbar(
                            'RFID',
                            'Teg o‘qilmoqda...',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Запустить RFID',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final rfid = Get.find<RfidController>();

                          await rfid.stop();
                          Get.back();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Завершить',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String text) => Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      );

  Widget _value(String text) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      );
}
