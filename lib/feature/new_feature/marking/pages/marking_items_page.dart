import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/marking_controller.dart';
import '../controller/marking_items_controller.dart';
import 'marking_rfid_page.dart';

class MarkingTaskPage extends StatelessWidget {
  const MarkingTaskPage({super.key, required this.markingId});

  final String markingId;

  @override
  Widget build(BuildContext context) {
    final itemsCtrl = Get.put(MarkingItemsController(markingId));

    return Scaffold(
      appBar: AppBar(title: const Text('Маркировка')),
      body: Obx(
        () {
          if (itemsCtrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: itemsCtrl.items.length,
            itemBuilder: (context, index) {
              final item = itemsCtrl.items[index];

              return GestureDetector(
                onTap: () {
                  Get.find<MarkingController>().selectedMarkingId.value =
                      markingId;
                  Get.to(() => MarkingRfidPage(marking: item, task: item));
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Объект: ${item.name ?? '-'}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const VerticalDivider(color: Colors.grey, thickness: 2),
                      Expanded(
                        child: Text(
                          'Статус: ${item.status ?? '—'}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
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
