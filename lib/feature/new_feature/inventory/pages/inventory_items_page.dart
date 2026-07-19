import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rfid/feature/new_feature/inventory/pages/read_rfid_page.dart';
import '../controllers/inventory_controller.dart';
import '../controllers/inventory_task_controller.dart';

class InventoryItemsPage extends StatelessWidget {
  const InventoryItemsPage(
      {super.key, required this.inventoryId, required this.inventory});

  final String inventoryId;
  final dynamic inventory;

  @override
  Widget build(BuildContext context) {
    final itemsCtrl =
        Get.isRegistered<InventoryTaskController>(tag: inventoryId)
            ? Get.find<InventoryTaskController>(tag: inventoryId)
            : Get.put(InventoryTaskController(inventoryId), tag: inventoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Инвентаризация №$inventoryId'),
      ),
      body: Obx(
        () {
          if (itemsCtrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (itemsCtrl.items.isEmpty) {
            return const Center(child: Text('Нет объектов'));
          }

          return ListView.builder(
            itemCount: itemsCtrl.items.length,
            itemBuilder: (context, index) {
              final item = itemsCtrl.items[index];
              final bool isFound = item.found >= item.total && item.total != 0;

              return GestureDetector(
                onTap: () {
                  Get.find<InventoryController>().selectedInventoryId.value =
                      inventoryId;

                  Get.to(() => ReadRfidPage(
                        inventory: inventory,
                        task: item,
                      ));
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isFound ? Colors.green : Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Объект: ${item.location}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        child:
                            VerticalDivider(color: Colors.grey, thickness: 2),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Прогресс: ${item.found}/${item.total}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                            Text(
                              'Статус: ${item.status}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
