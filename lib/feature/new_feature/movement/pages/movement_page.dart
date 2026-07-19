import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rfid/feature/new_feature/movement/controllers/movement_controller.dart';
import 'package:rfid/feature/new_feature/movement/pages/free_transfer_page.dart';
import 'package:rfid/feature/new_feature/movement/pages/movement_rfid_page.dart';
import 'package:rfid/feature/new_feature/inventory/pages/view_page.dart';

class MovementPage extends StatelessWidget {
  const MovementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movement = Get.put(MovementController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Перемещение'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'exchange') {
                movement.refreshMovements();
              } else if (value == 'view') {
                Get.to(const ViewPage());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'exchange',
                child: Text('Обмен'),
              ),
              const PopupMenuItem(
                value: 'view',
                child: Text('Просмотр'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Obx(() =>
              movement.isRefreshing.value ? const LinearProgressIndicator(minHeight: 3) : const SizedBox.shrink()),
        ),
      ),
      body: Obx(
        () {
          if (movement.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: movement.movements.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => Get.to(const FreeTransferPage()),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.open_in_new, color: Colors.blue),
                        SizedBox(width: 12),
                        Text('Свободное перемещение', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }
              final item = movement.movements[index - 1];

              return GestureDetector(
                onTap: () {
                  Get.to(MovementRfidPage(
                    task: item,
                    movement: item,
                  ));
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
                            Text('Перемещения №${item.name}  ',
                                style: const TextStyle(color: Colors.white, fontSize: 9)),
                            Text(item.destination, style: const TextStyle(color: Colors.white, fontSize: 9)),
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
                              style: const TextStyle(color: Colors.white, fontSize: 9),
                            ),
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
