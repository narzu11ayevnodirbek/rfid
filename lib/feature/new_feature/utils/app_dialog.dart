import 'package:flutter/material.dart';

/// Полноценные диалоги для ошибок и важных сообщений: причина и способ решения.
class AppDialog {
  AppDialog._();
  /// Показать диалог об ошибке с причиной и решением.
  /// [title] — заголовок (например «Ошибка отправки»).
  /// [message] — что произошло.
  /// [reason] — возможная причина (опционально).
  /// [solution] — что сделать (опционально).
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String? reason,
    String? solution,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: const TextStyle(fontSize: 15)),
              if (reason != null && reason.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text('Возможная причина:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(reason, style: const TextStyle(fontSize: 14)),
              ],
              if (solution != null && solution.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text('Что сделать:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(solution, style: const TextStyle(fontSize: 14)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  /// Показать диалог с информацией (успех или подсказка).
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? detail,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: const TextStyle(fontSize: 15)),
              if (detail != null && detail.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(detail, style: const TextStyle(fontSize: 14)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
