import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/view_controller.dart';
import '../models/tag_model.dart';
import '../../utils/rfid_trigger_hint.dart';
import 'item_info_page.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ViewController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Просмотр'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const RfidTriggerHint(),
              const SizedBox(height: 8),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await c.toggle();
                    },
                    icon: Icon(
                      c.isReading.value ? Icons.stop : Icons.play_arrow,
                    ),
                    label: Text(
                      c.isReading.value
                          ? 'Остановить чтение'
                          : 'Запустить чтение',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(
                  () {
                    final list = c.foundItems;
                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          'Пока нет считанных меток.\nНажмите «Запустить чтение» и жмите физическую кнопку на устройстве.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final TagModel item = list[index];
                        return ListTile(
                          tileColor: Colors.black,
                          leading: const Icon(Icons.inventory, color: Colors.white),
                          title: Text(
                            item.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            item.location,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            Get.to(() => ItemInfoPage(item: item));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

