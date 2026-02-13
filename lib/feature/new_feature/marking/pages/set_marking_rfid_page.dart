import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../inventory/pages/barcode_page.dart';
import '../../rfid/rfid_controller.dart';
import '../controller/marking_controller.dart';
import '../models/marking_item.dart';

class SetMarkingRfidPage extends StatefulWidget {
  const SetMarkingRfidPage({super.key, required this.item});

  final MarkingItem item;

  @override
  State<SetMarkingRfidPage> createState() => _SetMarkingRfidPageState();
}

class _SetMarkingRfidPageState extends State<SetMarkingRfidPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Единица ТМЦ')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Наименование'),
                  _value(widget.item.name),
                  _title('Инвентарный номер'),
                  _value(widget.item.markingNumber),
                  _title('Статус'),
                  _value(widget.item.status),
                  _title('Фото'),
                  const SizedBox(height: 12),
                  Center(
                    child: widget.item.photo.isNotEmpty
                        ? Image.network(widget.item.photo, height: 200)
                        : const Icon(Icons.image_not_supported, size: 120),
                  ),
                  const SizedBox(height: 12),
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
                          onChanged: (v) {},
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
                            final c = Get.find<MarkingController>();
                            final rfid = Get.find<RfidController>();

                            c.startScan(
                              markingId: widget.item.markingId,
                              taskId: widget.item.taskId,
                              itemId: widget.item.id,
                            );

                            await rfid.initOnce();
                            await rfid.start();

                            Get.snackbar('RFID', 'Teg o‘qilmoqda...');
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
                          onPressed: () {
                            final c = Get.find<MarkingController>();

                            if (c.scannedTags.isEmpty) {
                              Get.snackbar('Xato', 'Avval RFID o‘qing!');
                              return;
                            }

                            Get.back();
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Zavershit',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

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
