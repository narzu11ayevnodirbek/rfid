import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rfid/feature/new_feature/utils/rfid_trigger_hint.dart';
import 'package:rfid/feature/new_feature/movement/controllers/free_transfer_controller.dart';
import 'package:rfid/feature/new_feature/movement/models/location_model.dart';

class FreeTransferPage extends StatelessWidget {
  const FreeTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FreeTransferController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Свободное перемещение'),
      ),
      body: Obx(() {
        if (c.locationsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = c.scannedItems;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Куда перемещаем?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<LocationModel>(
                  value: c.selectedLocation.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('Выберите локацию'),
                  items: c.locations
                      .map(
                        (loc) => DropdownMenuItem(
                          value: loc,
                          child: Text(
                            loc.displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => c.selectedLocation.value = v,
                ),
                const SizedBox(height: 12),
                const RfidTriggerHint(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: c.isScanning.value ? () => c.stopScan() : () => c.startScan(),
                        icon: Icon(c.isScanning.value ? Icons.stop : Icons.qr_code_scanner),
                        label: Text(c.isScanning.value ? 'Стоп' : 'Сканировать'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: list.isEmpty ? null : () => c.clearScanned(),
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Очистить'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Считано меток: ${c.scannedCount}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: list.isEmpty
                      ? const Center(
                          child: Text(
                            'Отсканируйте объекты для перемещения. Ошибочную метку можно удалить по X.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final epc = list[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: const Icon(Icons.nfc),
                                title: Text(
                                  epc,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => c.removeScanned(epc),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: c.isSending.value || list.isEmpty ? null : () => c.submit(),
                  icon: c.isSending.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: const Text('Переместить'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
