import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/rfid_trigger_hint.dart';
import '../controllers/movement_rfid_scan_controller.dart';
import '../models/movement_task_model.dart';

/// Экран перемещения: Запустить RFID → список меток с кнопкой X → Стоп → Отправить на сервер.
class MovementRfidPage extends StatelessWidget {
  const MovementRfidPage({
    super.key,
    required this.movement,
    required this.task,
  });

  final dynamic movement;
  final MovementTaskModel task;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MovementRfidScanController>()) {
      Get.put(MovementRfidScanController(task));
    }
    final c = Get.find<MovementRfidScanController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Перемещение ${task.movementName.isNotEmpty ? task.movementName : task.name}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (task.sourceLocation != null && task.sourceLocation!.isNotEmpty)
                _infoRow('Откуда', task.sourceLocation!),
              _infoRow('Куда', task.destination),
              const SizedBox(height: 16),
              const RfidTriggerHint(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: c.isScanning.value ? () => c.stopScan() : () => c.startScan(),
                      icon: Icon(c.isScanning.value ? Icons.stop : Icons.play_arrow),
                      label: Text(c.isScanning.value ? 'Стоп' : 'Запустить RFID'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: c.scannedCount == 0 ? null : () => c.clearAll(),
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Очистить'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                'Считано меток: ${c.scannedCount}',
                style: const TextStyle(fontSize: 14),
              )),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  final list = c.scannedList;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        'Нажмите «Запустить RFID», затем считывайте метки физической кнопкой. Удалите ошибочные по X.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final epc = list[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          leading: const Icon(Icons.nfc),
                          title: Text(epc, style: const TextStyle(fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => c.removeScanned(epc),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              Obx(() => FilledButton.icon(
                onPressed: c.isSending.value || c.scannedCount == 0
                    ? null
                    : () => c.submit(),
                icon: c.isSending.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: const Text('Отправить на сервер'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
