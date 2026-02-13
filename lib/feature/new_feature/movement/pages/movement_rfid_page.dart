import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/movement/pages/set_movement_rfid_page.dart';
import '../../../../injector_container.dart';
import '../controllers/movement_read_rfid_controller.dart';
import '../models/movement_item.dart';
import '../models/movement_task_model.dart';
import '../movement_repository.dart';

class MovementRfidPage extends StatefulWidget {
  const MovementRfidPage({
    super.key,
    required this.movement,
    required this.task,
  });

  final dynamic movement;
  final MovementTaskModel task;

  @override
  State<MovementRfidPage> createState() => _MovementRfidPageState();
}

class _MovementRfidPageState extends State<MovementRfidPage> {
  late Future<List<MovementItem>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = sl<MovementRepository>()
        .fetchMovementItems(int.parse(widget.movement.movementId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ПЕРЕМЕЩЕНИЕ №${widget.task.name}'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<MovementItem>>(
          future: futureItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final items = snapshot.data ?? [];

            if (!Get.isRegistered<MovementReadRfidController>()) {
              Get.put(
                MovementReadRfidController(widget.task, items),
              );
            }

            final c = Get.find<MovementReadRfidController>();

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'Hozircha obyektlar yo‘q',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        stat('Всего', c.total.value),
                        stat('Найдено', c.moved.value),
                        stat('Не найдено', c.notMoved.value),
                        stat('Чтений', c.readCount.value),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final item = items[index];

                          final isFound = c.moved.value > 0 &&
                              c.items.any((e) => e.id == item.id);

                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                SetMovementRfidPage(item: item),
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
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget stat(String title, int value) => Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
