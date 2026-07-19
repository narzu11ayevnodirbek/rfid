import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rfid/feature/new_feature/marking/controller/marking_controller.dart';
import 'package:rfid/feature/new_feature/marking/pages/marking_items_page.dart';
import 'package:rfid/feature/new_feature/inventory/pages/view_page.dart';

class MarkingPage extends StatelessWidget {
  const MarkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inv = Get.put(MarkingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Маркировка'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'exchange') {
                inv.refreshMarkings();
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
          child:
              Obx(() => inv.isRefreshing.value ? const LinearProgressIndicator(minHeight: 3) : const SizedBox.shrink()),
        ),
      ),
      body: Obx(
        () {
          if (inv.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: inv.markings.length,
            itemBuilder: (context, index) {
              final item = inv.markings[index];

              return GestureDetector(
                onTap: () {
                  inv.selectedMarkingId.value = item.id;
                  Get.to(() => MarkingTaskPage(markingId: item.id));
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
                            Text('Маркировка №${item.id}  ', style: const TextStyle(color: Colors.white, fontSize: 9)),
                            Text('${item.name}: ${item.type}',
                                style: const TextStyle(color: Colors.white, fontSize: 9)),
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
                            Text('Тип: ${item.name}', style: const TextStyle(color: Colors.white, fontSize: 9)),
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
