import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/marking/models/marking_item.dart';
import 'package:rf_id_test/feature/new_feature/marking/models/marking_task_model.dart';
import 'package:rf_id_test/feature/new_feature/marking/pages/set_marking_rfid_page.dart';
import '../../../../injector_container.dart';
import '../../rfid/rfid_session.dart';
import '../controller/marking_controller.dart';
import '../controller/marking_read_rfid_controller.dart';
import '../marking_repository.dart';

class MarkingRfidPage extends StatefulWidget {
  const MarkingRfidPage({super.key, required this.marking, required this.task});

  final dynamic marking;
  final MarkingTaskModel task;

  @override
  State<MarkingRfidPage> createState() => _MarkingRfidPageState();
}

class _MarkingRfidPageState extends State<MarkingRfidPage> {
  late Future<List<MarkingItem>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = sl<MarkingRepository>().fetchMarkingItems(
        int.parse(widget.marking.markingId), int.parse(widget.task.id));
  }

  final markingController = Get.find<MarkingController>();

  @override
  Widget build(BuildContext context) {
    RfidSession.instance.currentMode = RfidMode.marking;
    final c = Get.put(MarkingReadRfidController(widget.marking));

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
                  child: FutureBuilder<List<MarkingItem>>(
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

                          final isBound =
                              markingController.scannedTags.isNotEmpty;

                          return GestureDetector(
                            onTap: () {
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
                                      style:
                                          const TextStyle(color: Colors.white),
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
