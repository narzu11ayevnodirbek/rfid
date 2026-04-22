import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/marking/pages/set_marking_rfid_page.dart';
// import 'package:rf_id_test/feature/new_feature/marking/models/marking_item.dart';
// import 'package:rf_id_test/feature/new_feature/marking/models/marking_task_model.dart';
// import 'package:rf_id_test/feature/new_feature/marking/pages/set_marking_rfid_page.dart';
import '../../rfid/rfid_session.dart';
import '../controller/marking_controller.dart';
import '../controller/marking_read_rfid_controller.dart';
import '../models/marking_item.dart';
import '../models/marking_task_model.dart';

class MarkingRfidPage extends StatefulWidget {
  const MarkingRfidPage({super.key, required this.marking, required this.task});

  final dynamic marking;
  final MarkingTaskModel task;

  @override
  State<MarkingRfidPage> createState() => _MarkingRfidPageState();
}

class _MarkingRfidPageState extends State<MarkingRfidPage> {
  late final List<MarkingItem> items;

  @override
  void initState() {
    super.initState();
    // Используем items, уже пришедшие в задаче из API get_marking_tasks_for_mobile.php
    items = widget.task.items
        .map(
          (e) => MarkingItem.fromJson(
            Map<String, dynamic>.from(e),
            markingId: widget.task.markingId,
            taskId: widget.task.id,
          ),
        )
        .toList();
  }

  final markingController = Get.find<MarkingController>();

  @override
  Widget build(BuildContext context) {
    RfidSession.instance.currentMode = RfidMode.marking;
    final c = Get.put(MarkingReadRfidController(widget.task));

    return Scaffold(
      appBar: AppBar(title: Text('МАРКИРОВКА №${widget.marking.name}')),
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
                    stat('Привязано', c.marked.value),
                    stat('Не привязано', c.notMarked.value),
                    stat('Чтений', c.readCount.value),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Hozircha obyektlar yo‘q',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final item = items[index];

                            final isBound = markingController
                                .completedItemIds
                                .contains(item.id);

                            return GestureDetector(
                              onTap: isBound
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              SetMarkingRfidPage(item: item),
                                        ),
                                      );
                                    },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isBound ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    if (isBound)
                                      const Icon(Icons.check_circle,
                                          color: Colors.white)
                                  ],
                                ),
                              ),
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
