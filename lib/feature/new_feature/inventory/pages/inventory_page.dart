import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/inventory/pages/database_page.dart';
import '../controllers/inventory_controller.dart';
import 'inventory_items_page.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inv = Get.put(InventoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Инвентаризация'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'exchange') {
                inv.refreshInventories();
              } else if (value == 'database') {
                Get.to(const DatabasePage());
              } else if (value == 'signout') {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text(
                      'Выход из аккаунта',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'Вы действительно хотите выйти из аккаунта?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                      FilledButton(
                        style:
                            FilledButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {},
                        child: const Text('Выйти'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'exchange',
                child: Text('Обмен'),
              ),
              const PopupMenuItem(
                value: 'database',
                child: Text('Вся БД'),
              ),
              const PopupMenuItem(
                value: 'signout',
                child: Text('Выход'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Obx(() => inv.isRefreshing.value
              ? const LinearProgressIndicator(minHeight: 3)
              : const SizedBox.shrink()),
        ),
      ),
      body: Obx(
        () {
          if (inv.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final assignedInventories = inv.inventories
              .where((item) => item.statusCode == 'assigned')
              .toList();

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: assignedInventories.length,
            itemBuilder: (context, index) {
              final item = assignedInventories[index];

              return GestureDetector(
                onTap: () {
                  inv.selectedInventoryId.value = item.id;
                  Get.to(() => InventoryItemsPage(
                      inventoryId: item.id, inventory: item));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Инвентаризация №${item.name}  ',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9)),
                            Text(item.userName ?? '',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Дата создания: ${item.createdAt}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 9),
                            ),
                            Text('Тип: ${item.type}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9)),
                          ],
                        ),
                      )
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
