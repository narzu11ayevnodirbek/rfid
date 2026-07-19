import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:rf_id_test/feature/new_feature/inventory/pages/set_rfid_page.dart';
// import 'package:rf_id_test/feature/new_feature/rfid/rfid_controller.dart';
// import 'package:rf_id_test/feature/new_feature/utils/rfid_trigger_hint.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../../../infrastructure/di/injector_container.dart';
import '../../rfid/rfid_controller.dart';
import '../../utils/rfid_trigger_hint.dart';
import '../controllers/inventory_controller.dart';
import '../controllers/read_rfid_controller.dart';
import '../models/inventory_item.dart';
import '../models/inventory_task_model.dart';
import '../repositories/inventory_repository.dart';

class ReadRfidPage extends StatefulWidget {
  const ReadRfidPage({super.key, required this.inventory, required this.task});

  final dynamic inventory;
  final InventoryTaskModel task;

  @override
  State<ReadRfidPage> createState() => _ReadRfidPageState();
}

class _ReadRfidPageState extends State<ReadRfidPage> {
  late Future<List<InventoryItem>> futureItems;

  @override
  void initState() {
    super.initState();

    futureItems = sl<InventoryRepository>()
        .fetchInventoryItems(int.parse(widget.inventory.id));
  }

  final invController = Get.find<InventoryController>();

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ReadRfidController(widget.inventory, widget.task));
    final invController = Get.find<InventoryController>();
    return Scaffold(
      appBar: AppBar(title: Text('Инвентаризация №${widget.inventory.name}')),
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    stat('Всего', c.total.value),
                    stat('Найдено', c.found.value),
                    stat('Не найдено', c.notFound.value),
                    stat('Лишнеe', c.extra.value),
                    stat('Чтений', c.readCount.value),
                  ],
                ),
                const SizedBox(height: 12),
                const RfidTriggerHint(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () async {
                          final rfid = Get.find<RfidController>();
                        if (c.isReading.value) {
                          invController.stopScan();
                            await rfid.stop();
                            await c.stop();
                          } else {
                          invController.selectedInventoryId.value =
                              widget.inventory.id;
                          invController.startScan();
                            await rfid.initOnce();
                            await c.start();
                            await rfid.start();
                          }
                        },
                        icon: Icon(
                          c.isReading.value ? Icons.stop : Icons.play_arrow,
                        ),
                        label: Text(c.isReading.value ? 'Остановить RFID' : 'Запустить RFID'),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        await invController.finishTaskScan(task: widget.task);
                      },
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Отправить на сервер'),
                    ),
                  ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(
                    () {
                      final tags = invController.scannedTags;
                      if (tags.isEmpty) {
                        return const Center(
                          child: Text(
                            'Пока нет считанных меток.\nНажмите «Запустить RFID» и жмите физическую кнопку на устройстве.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: tags.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final epc = tags[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.nfc, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    epc,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stat(String title, int value) => Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
}
