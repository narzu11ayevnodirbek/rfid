import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../rfid/rfid_controller.dart';
import '../controllers/inventory_controller.dart';
import '../models/inventory_item.dart';
import '../models/inventory_task_model.dart';
import 'barcode_page.dart';

class SetRfidPage extends StatelessWidget {
  const SetRfidPage({super.key, required this.item, required this.task});

  final InventoryItem item;
  final InventoryTaskModel task;

  @override
  Widget build(BuildContext context) {
    final inv = Get.find<InventoryController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Единица ТМЦ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Наименование'),
                  _value(item.name),
                  _title('Инвентарный номер'),
                  _value(item.inventoryNumber),
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
                  const Text(
                    'O‘qilgan RFID lar:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // ...inv.scannedTags.map((e) => Text(e)).toList(),
                  if (inv.lastScanSuccess.value)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Teg muvaffaqiyatli o‘qildi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                  SizedBox(
                    width: 100,
                    // height: 200,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const BarcodePage());
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black,
                        ),
                        child: Image.asset(
                          'assets/images/barcode.png',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Мощность RFID считывателя',
                          style: TextStyle(color: Colors.white),
                        ),
                        Slider(
                          value: 10,
                          max: 10,
                          activeColor: Colors.blue,
                          divisions: 10,
                          label: '100%',
                          onChanged: (v) {
                            // c.powerStep.value = v.toInt();
                            // c.applyPower();
                          },
                        ),
                        Text(
                          'Текушая мошност 100%',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        FilledButton(
                          onPressed: () async {
                            final inv = Get.find<InventoryController>();
                            final rfid = Get.find<RfidController>();

                            inv.selectedInventoryId.value = task.inventoryId;

                            await rfid.initOnce();
                            inv.startScan();
                            await rfid.start();

                            Get.snackbar('RFID', 'Считывание тега...');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Запустить RFID',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Spacer(),
                        FilledButton(
                            onPressed: () async {
                              try {
                                final inv = Get.find<InventoryController>();

                                if (inv.scannedTags.isEmpty) {
                                  Get.snackbar('Ошибка', 'Сначала отсканируйте RFID!');
                                  return;
                                }

                                final epc = inv.scannedTags.last;

                                await inv.finishItem(
                                  taskId: task.inventoryId,
                                  item: item,
                                  epc: epc,
                                );
                                Navigator.pop(context);
                                Get.snackbar(
                                  'Успешно',
                                  'Инвентаризация закрыта!',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                throw Exception();
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: Text(
                              'Завершить',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ))
                      ],
                    ),
                  ),
                ],
              );
            },
          )),
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
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      );
}
