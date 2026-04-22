import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../inventory/pages/barcode_page.dart';
import '../../rfid/rfid_controller.dart';
import '../../utils/app_dialog.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/rfid_trigger_hint.dart';
import '../controllers/movement_read_rfid_controller.dart';
import '../models/movement_item.dart';
import '../services/movement_service.dart';

class SetMovementRfidPage extends StatefulWidget {
  const SetMovementRfidPage({super.key, required this.item});

  final MovementItem item;

  @override
  State<SetMovementRfidPage> createState() => _SetMovementRfidPageState();
}

class _SetMovementRfidPageState extends State<SetMovementRfidPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   if (Get.isRegistered<MovementReadRfidController>()) {
  //     Get.find<MovementReadRfidController>().clearLastScan();
  //   }
  // }

  final RxString photo = ''.obs;
  final MovementService _service = MovementService(); // GetX DI ishlatmasangiz shunday

  @override
  void initState() {
    super.initState();

    () async {
      final p = await _service.getItemPhoto(
        movementId: int.parse(widget.item.movementId),
        itemId: widget.item.id,
      );
      photo.value = p;
      print('PHOTO LOADED: "$p"');
    }();
  }

  @override
  Widget build(BuildContext context) {

    print('PHOTO VALUE: "${widget.item.photo}"');
    print('PHOTO URL: "https://mderp.uz/${widget.item.photo}"');
    final rfid = Get.find<RfidController>();
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(title: const Text('Единица ТМЦ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Obx(() {
              final c = Get.isRegistered<MovementReadRfidController>()
                  ? Get.find<MovementReadRfidController>()
                  : null;
              return Column(
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
                  // Center(
                  //   child: item.photo.isNotEmpty
                  //       ? Image.network('https://mderp.uz/${item.photo}', height: 200)
                  //       : const Icon(Icons.image_not_supported, size: 120),
                  // ),

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
                  if (c != null && c.lastScanSuccess.value)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Тег прочитан',
                        style: TextStyle(color: Colors.white),
                      ),
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
                  const RfidTriggerHint(),
                  const SizedBox(height: 16),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            await rfid.initOnce();
                            await rfid.start();

                            AppSnackbar.showInfo('RFID',
                                'Чтение только по нажатию физической кнопки на считывателе.');
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

                            if (Get.isRegistered<
                                MovementReadRfidController>()) {
                              final c = Get.find<MovementReadRfidController>();
                              final epc = c.lastScannedEpc;
                              if (epc != null && epc.isNotEmpty) {
                                final result =
                                    await c.sendMovement(epc, widget.item);
                                if (!result.ok) {
                                  final msg = result.errorMessage ??
                                      'Сервер не принял запрос';
                                  if (msg.contains('Неизвестный') ||
                                      msg.contains('unknown')) {
                                    await AppDialog.showError(
                                      context,
                                      title: 'Неизвестный объект',
                                      message:
                                          'Метка считана, но её нет в базе системы.',
                                      reason:
                                          'Данная RFID-метка не привязана ни к одному объекту в учёте.',
                                      solution:
                                          'Проверьте маркировку объекта. Если объект должен быть в системе — сначала выполните привязку метки к объекту в разделе маркировки.',
                                    );
                                  } else {
                                    await AppDialog.showError(
                                      context,
                                      title: 'Ошибка отправки в базу',
                                      message:
                                          'Не удалось отправить данные о перемещении на сервер.',
                                      reason: msg,
                                      solution:
                                          'Проверьте подключение к интернету и повторите попытку. При повторении ошибки обратитесь к администратору.',
                                    );
                                  }
                                  return;
                                }
                                AppSnackbar.showSuccess(
                                    'Успешно', 'Данные отправлены в базу');
                              } else {
                                await AppDialog.showError(
                                  context,
                                  title: 'Нет данных',
                                  message: 'Сначала прочитайте метку RFID.',
                                  solution:
                                      'Нажмите «Запустить RFID», затем нажмите физическую кнопку на считывателе, поднеся метку к устройству.',
                                );
                                return;
                              }
                            }
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
              );
            }),
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
