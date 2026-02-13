import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/inventory/pages/set_rfid_page.dart';
import '../../../../injector_container.dart';
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
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<InventoryItem>>(
                    future: futureItems,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      final items = snapshot.data!;
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            'Hozircha obyektlar yo‘q',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final item = items[index];

                          final isFound =
                              invController.scannedTags.contains(item.rfid);
                          print('Scanned tags: ${invController.scannedTags}');
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SetRfidPage(
                                    item: item,
                                    task: widget.task,
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isFound ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  if (isFound)
                                    const Icon(Icons.check_circle,
                                        color: Colors.white)
                                ],
                              ),
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
