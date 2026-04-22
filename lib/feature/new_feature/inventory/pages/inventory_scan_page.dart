// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:rf_id_test/feature/new_feature/inventory/controllers/inventory_scan_controller.dart';
// // import 'package:rf_id_test/feature/new_feature/inventory/models/inventory_plan_model.dart';
// // import 'package:rf_id_test/feature/new_feature/utils/app_snackbar.dart';
// // import 'package:rf_id_test/feature/new_feature/utils/rfid_trigger_hint.dart';
//
// import '../../utils/app_snackbar.dart';
// import '../../utils/rfid_trigger_hint.dart';
// import '../controllers/inventory_scan_controller.dart';
//
// /// Экран режима сканирования инвентаризации по ТЗ:
// /// — Прогресс «Найдено: X из Y».
// /// — Список: зелёный (на месте), красный (излишек), серый (недостача).
// /// — Кнопки: Сохранить черновик, Завершить.
// class InventoryScanPage extends StatelessWidget {
//   const InventoryScanPage({
//     super.key,
//     required this.inventoryId,
//     required this.inventoryName,
//   });
//
//   final int inventoryId;
//   final String inventoryName;
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.put(
//       InventoryScanController(inventoryId: inventoryId, inventoryName: inventoryName),
//       tag: 'scan_$inventoryId',
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Сканирование №$inventoryName'),
//       ),
//       body: Obx(() {
//         if (c.planLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (c.planError.value.isNotEmpty && c.plan.value == null) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(c.planError.value, textAlign: TextAlign.center),
//                   const SizedBox(height: 16),
//                   FilledButton(
//                     onPressed: () => c.loadPlan(),
//                     child: const Text('Повторить загрузку'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//         final plan = c.plan.value;
//         if (plan == null || plan.expectedItems.isEmpty) {
//           return const Center(child: Text('Нет объектов в плане'));
//         }
//
//         return SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   children: [
//                     Text(
//                       plan.locationName.isNotEmpty
//                           ? plan.locationName
//                           : 'Локация не указана',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 8),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: LinearProgressIndicator(
//                         value: c.totalCount > 0
//                             ? c.foundCount / c.totalCount
//                             : 0.0,
//                         minHeight: 24,
//                         backgroundColor: Colors.grey.shade300,
//                         valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Найдено: ${c.foundCount} из ${c.totalCount}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _chip('Подтверждено', c.foundCount, Colors.green),
//                         _chip('Недостача', c.missingCount, Colors.grey),
//                         _chip('Излишек', c.extraCount, Colors.red),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const RfidTriggerHint(),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: FilledButton.icon(
//                         onPressed: c.isScanning.value
//                             ? () => c.stopScan()
//                             : () async {
//                                 await c.startScan();
//                                 AppSnackbar.showInfo(
//                                     'RFID', 'Чтение только по нажатию физической кнопки на считывателе.');
//                               },
//                         icon: Icon(
//                           c.isScanning.value ? Icons.stop : Icons.play_arrow,
//                         ),
//                         label: Text(c.isScanning.value ? 'Стоп' : 'Старт'),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   children: [
//                     ...c.matchItems.map(
//                       (e) => _listTile(
//                         context,
//                         e.name,
//                         e.epc,
//                         Colors.green,
//                         Icons.check_circle,
//                         'На месте',
//                       ),
//                     ),
//                     ...c.missingItems.map(
//                       (e) => _listTile(
//                         context,
//                         e.name,
//                         e.epc,
//                         Colors.grey,
//                         Icons.remove_circle_outline,
//                         'Недостача',
//                       ),
//                     ),
//                     ...c.extraEpcs.map(
//                       (epc) => _listTile(
//                         context,
//                         'Чужая метка',
//                         epc,
//                         Colors.red,
//                         Icons.warning_amber,
//                         'Излишек',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: c.isSending.value ? null : () => c.saveDraft(),
//                         icon: const Icon(Icons.save),
//                         label: const Text('Сохранить черновик'),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: FilledButton.icon(
//                         onPressed: c.isSending.value
//                             ? null
//                             : () async {
//                                 await c.finish(onSuccess: () async  {
//                                   Get.back(result: true);
//                                   AppSnackbar.showSuccess(
//                                       'Готово', 'Итоги инвентаризации отправлены.');
//                                 });
//                               },
//                         icon: c.isSending.value
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(strokeWidth: 2),
//                               )
//                             : const Icon(Icons.done_all),
//                         label: const Text('Завершить'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _chip(String label, int value, Color color) {
//     return Chip(
//       avatar: CircleAvatar(backgroundColor: color, radius: 10),
//       label: Text('$label: $value'),
//     );
//   }
//
//   Widget _listTile(
//     BuildContext context,
//     String title,
//     String subtitle,
//     Color color,
//     IconData icon,
//     String status,
//   ) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 6),
//       color: color.withOpacity(0.15),
//       child: ListTile(
//         leading: Icon(icon, color: color, size: 28),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//         subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: color)),
//         trailing: Text(
//           status,
//           style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
