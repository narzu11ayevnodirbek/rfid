import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rfid/feature/new_feature/inventory/pages/barcode_page.dart';
import 'package:rfid/feature/new_feature/rfid/rfid_controller.dart';
import 'package:rfid/feature/new_feature/utils/app_dialog.dart';
import 'package:rfid/feature/new_feature/utils/app_snackbar.dart';
import 'package:rfid/feature/new_feature/utils/rfid_trigger_hint.dart';
import 'package:rfid/feature/new_feature/marking/controller/marking_controller.dart';
import 'package:rfid/feature/new_feature/marking/models/marking_item.dart';

class SetMarkingRfidPage extends StatefulWidget {
  const SetMarkingRfidPage({super.key, required this.item});

  final MarkingItem item;

  @override
  State<SetMarkingRfidPage> createState() => _SetMarkingRfidPageState();
}

class _SetMarkingRfidPageState extends State<SetMarkingRfidPage> {
  final RxString photo = ''.obs;
  final RxBool _isReading = false.obs;

  @override
  void initState() {
    super.initState();
    final ctrl = Get.find<MarkingController>();
    ctrl.lastScanSuccess.value = false;

    () async {
      final p = await ctrl.loadItemPhoto(
        markingId: int.parse(widget.item.markingId),
        itemId: widget.item.id,
      );
      photo.value = p;
      print('PHOTO LOADED: $p');
    }();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Единица ТМЦ')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Obx(() {
                final c = Get.find<MarkingController>();
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _title('Наименование'),
                  _value(widget.item.name),
                  _title('Инвентарный номер'),
                  _value(widget.item.markingNumber),
                  _title('Статус'),
                  _value(widget.item.status),
                  _title('Фото'),
                  const SizedBox(height: 12),
                  Center(
                    child: Obx(() {
                      final p = photo.value;
                      if (p.isEmpty) return const Icon(Icons.image_not_supported, size: 120);

                      final url = p.startsWith('http') ? p : 'https://mderp.uz/$p';
                      return Image.network(
                        url,
                        height: 200,
                        errorBuilder: (_, e, __) {
                          print('IMG ERROR: $e');
                          return const Icon(Icons.broken_image, size: 120);
                        },
                      );
                    }),
                  ),
                  if (c.lastScanSuccess.value)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Тег прочитан',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              c.lastEpc.value.isEmpty ? '—' : c.lastEpc.value,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 100,
                    // height: 200,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const BarcodePage());
                        print(widget.item.photo);
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
                  const RfidTriggerHint(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        Obx(() {
                          final isReading = _isReading.value;
                          return FilledButton(
                            onPressed: () async {
                              final c = Get.find<MarkingController>();
                              final rfid = Get.find<RfidController>();

                              if (!isReading) {
                                c.startScan(
                                  markingId: widget.item.markingId,
                                  taskId: widget.item.taskId,
                                  itemId: widget.item.id,
                                );

                                await rfid.initOnce();
                                await rfid.start();

                                _isReading.value = true;

                                if (Get.isSnackbarOpen) {
                                  await Get.closeCurrentSnackbar();
                                }

                                AppSnackbar.showInfo(
                                  'RFID',
                                  'Сканирование запущено. Нажимайте физическую кнопку, чтобы читать метки.',
                                );
                              } else {
                                await rfid.stop();
                                _isReading.value = false;

                                if (Get.isSnackbarOpen) {
                                  await Get.closeCurrentSnackbar();
                                }

                                AppSnackbar.showInfo(
                                  'RFID',
                                  'Сканирование остановлено.',
                                );
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: Text(
                              isReading ? 'Стоп' : 'Запустить RFID',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                          );
                        }),
                        const Spacer(),
                        FilledButton(
                          onPressed: (c.lastScanSuccess.value || c.scannedTags.isNotEmpty)
                              ? () async {
                                  final ctrl = Get.find<MarkingController>();
                                  final result = await ctrl.finishMarkingItem(
                                    widget.item.id,
                                    markingId: widget.item.markingId,
                                    taskId: widget.item.taskId,
                                  );
                                  if (!result.ok) {
                                    await AppDialog.showError(
                                      context,
                                      title: 'Ошибка отправки в базу',
                                      message: result.errorMessage ??
                                          'Не удалось отправить данные о привязанной метке на сервер.',
                                      reason: 'Сервер вернул ошибку или нет связи.',
                                      solution:
                                          'Проверьте подключение к интернету, при необходимости войдите в приложение снова и повторите попытку.',
                                    );
                                    return;
                                  }

                                  if (_isReading.value) {
                                    try {
                                      final rfid = Get.find<RfidController>();
                                      await rfid.stop();
                                    } catch (_) {}
                                    _isReading.value = false;
                                  }

                                  Get.closeAllSnackbars();
                                  AppSnackbar.showSuccess('Успешно', 'Данные отправлены в базу');

                                  await Future.delayed(const Duration(milliseconds: 250));
                                  Get.back();
                                }
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                (c.lastScanSuccess.value || c.scannedTags.isNotEmpty) ? Colors.black : Colors.grey,
                          ),
                          child: const Text(
                            'Завершить',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              }),
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
