import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';

/// One line of a [showMessageDialog], with its own colour.
class MessageDialogLine {
  const MessageDialogLine(this.text, {this.tone = StatusTone.neutral});

  final String text;
  final StatusTone tone;
}

/// A dialog that reports the outcome of an action (success, partial result,
/// error) and is closed with one button.
Future<void> showMessageDialog(
  BuildContext context, {
  required String title,
  required List<MessageDialogLine> lines,
  StatusTone tone = StatusTone.neutral,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final colors = dialogContext.statusColors;
      return AlertDialog(
        icon: Icon(
          switch (tone) {
            StatusTone.success => Icons.check_circle_outline,
            StatusTone.danger => Icons.error_outline,
            StatusTone.warning => Icons.warning_amber_outlined,
            StatusTone.info || StatusTone.neutral => Icons.info_outline,
          },
          color: colors.foreground(tone),
        ),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  line.text,
                  style: TextStyle(
                    color: line.tone == StatusTone.neutral
                        ? null
                        : colors.foreground(line.tone),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(dialogContext.l10n.commonOk),
          ),
        ],
      );
    },
  );
}
