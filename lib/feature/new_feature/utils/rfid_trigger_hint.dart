import 'package:flutter/material.dart';

/// Подсказка на всех экранах с RFID: сканер читает метки только при нажатии физической кнопки на устройстве.
class RfidTriggerHint extends StatelessWidget {
  const RfidTriggerHint({super.key});

  static const String text =
      'После нажатия «Запустить RFID» читайте метки, нажимая физическую кнопку на считывателе. '
      'Метки не читаются непрерывно — только в момент нажатия кнопки.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.touch_app, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
