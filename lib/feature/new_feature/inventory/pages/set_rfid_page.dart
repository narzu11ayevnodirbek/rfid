import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rfid/feature/new_feature/rfid/rfid_controller.dart';
import 'package:rfid/feature/new_feature/utils/app_dialog.dart';
import 'package:rfid/feature/new_feature/utils/app_snackbar.dart';
import 'package:rfid/feature/new_feature/utils/rfid_trigger_hint.dart';
import 'package:rfid/feature/new_feature/inventory/controllers/inventory_controller.dart';
import 'package:rfid/feature/new_feature/inventory/models/inventory_item.dart';
import 'package:rfid/feature/new_feature/inventory/models/inventory_task_model.dart';
import 'package:rfid/feature/new_feature/inventory/pages/barcode_page.dart';

class SetRfidPage extends StatefulWidget {
  const SetRfidPage({super.key, required this.item, required this.task});

  final InventoryItem item;
  final InventoryTaskModel task;

  @override
  State<SetRfidPage> createState() => _SetRfidPageState();
}

class _SetRfidPageState extends State<SetRfidPage> {
  double _power = 10;

  @override
  void initState() {
    super.initState();
    Get.find<InventoryController>().lastScanSuccess.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final inv = Get.find<InventoryController>();
    final item = widget.item;
    final task = widget.task;
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
                          value: _power,
                          max: 10,
                          activeColor: Colors.blue,
                          divisions: 10,
                          label: '${(_power * 10).toInt()}%',
                          onChanged: (v) {
                            setState(() {
                              _power = v;
                            });
                            final rfid = Get.find<RfidController>();
                            rfid.setPowerStep(v.toInt());
                          },
                        ),
                        Text(
                          'Текущая мощность ${(_power * 10).toInt()}%',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const RfidTriggerHint(),
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

                            AppSnackbar.showInfo('RFID', 'Чтение только по нажатию физической кнопки на считывателе.');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Запустить RFID',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Spacer(),
                        FilledButton(
                            onPressed: () async {
                              try {
                                final inv = Get.find<InventoryController>();

                                if (inv.scannedTags.isEmpty) {
                                  await AppDialog.showError(
                                    context,
                                    title: 'Нет данных',
                                    message: 'Сначала прочитайте метку RFID, нажав физическую кнопку на считывателе.',
                                    solution:
                                        'Нажмите «Запустить RFID», затем поднесите метку к считывателю и нажмите физическую кнопку на устройстве.',
                                  );
                                  return;
                                }

                                final epc = inv.scannedTags.last;

                                final ok = await inv.finishItem(
                                  taskId: task.id,
                                  item: widget.item,
                                  epc: epc,
                                );
                                if (!ok) {
                                  await AppDialog.showError(
                                    context,
                                    title: 'Ошибка отправки в базу',
                                    message: 'Не удалось отправить данные о прочитанной метке и объекте на сервер.',
                                    reason:
                                        'Сервер не принял запрос. Возможны проблемы с сетью, авторизацией или занятостью сервера.',
                                    solution:
                                        'Проверьте подключение к интернету, повторно войдите в приложение при необходимости и попробуйте снова. Если ошибка повторяется — обратитесь к администратору.',
                                  );
                                  return;
                                }
                                Navigator.pop(context);
                                AppSnackbar.showSuccess('Успешно', 'Данные отправлены в базу. Инвентаризация закрыта.');
                              } catch (e) {
                                await AppDialog.showError(
                                  context,
                                  title: 'Ошибка отправки',
                                  message: 'Не удалось отправить данные в базу данных.',
                                  reason: e.toString(),
                                  solution:
                                      'Проверьте интернет-соединение и повторите попытку. При повторении ошибки обратитесь в поддержку.',
                                );
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              'Завершить',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
