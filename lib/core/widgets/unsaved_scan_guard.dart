import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/widgets/confirm_dialog.dart';

class UnsavedScanGuard extends StatelessWidget {
  const UnsavedScanGuard({
    super.key,
    required this.hasUnsentTags,
    required this.child,
  });

  final bool hasUnsentTags;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !hasUnsentTags,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await showConfirmDialog(
          context,
          title: l10n.scanLeaveTitle,
          message: l10n.scanLeaveMessage,
          confirmLabel: l10n.scanLeaveConfirm,
          isDestructive: true,
        );
        if (leave && context.mounted) Navigator.of(context).pop();
      },
      child: child,
    );
  }
}
