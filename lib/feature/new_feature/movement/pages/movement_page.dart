import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/movement/controllers/movement_controller.dart';
import 'package:rf_id_test/feature/new_feature/movement/pages/movement_rfid_page.dart';

class MovementPage extends StatelessWidget {
  const MovementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movement = Get.put(MovementController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Перемишение'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'exchange') {
                movement.refreshMovements();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'exchange',
                child: Text('Обмен'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Obx(() => movement.isRefreshing.value
              ? const LinearProgressIndicator(minHeight: 3)
              : const SizedBox.shrink()),
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
            itemCount: movement.movements.length,
            itemBuilder: (context, index) {
              final item = movement.movements[index];

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
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9)),
                            Text(item.destination,
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
