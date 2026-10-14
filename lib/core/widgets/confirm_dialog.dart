import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';

/// Asks the user to confirm an action. Resolves to `true` only when the
/// confirm button was pressed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool isDestructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final scheme = Theme.of(dialogContext).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonCancel),
          ),
          FilledButton(
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  )
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

/// Runs [onConfirmed] after the user confirms. Lets a button ask first
/// without putting any branching in the page:
///
/// ```dart
/// onPressed: () => confirmThen(
///   context,
///   title: l10n.settingsSignOutTitle,
///   message: l10n.settingsSignOutMessage,
///   confirmLabel: l10n.settingsSignOutConfirm,
///   onConfirmed: () => bloc.add(const SessionSignOutRequested()),
/// ),
/// ```
Future<void> confirmThen(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirmed,
  bool isDestructive = false,
}) async {
  final confirmed = await showConfirmDialog(
    context,
    title: title,
    message: message,
    confirmLabel: confirmLabel,
    isDestructive: isDestructive,
  );
  if (confirmed) onConfirmed();
}
