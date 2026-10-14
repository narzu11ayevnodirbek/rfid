import 'package:flutter/material.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/widgets/message_dialog.dart';
import 'package:rfid/features/movement/domain/entities/transfer_result.dart';

Future<void> showTransferResultDialog(
  BuildContext context,
  TransferResult result,
) {
  final l10n = context.l10n;
  return showMessageDialog(
    context,
    title: l10n.movementResultTitle,
    tone: result.hasProblems ? StatusTone.warning : StatusTone.success,
    lines: [
      MessageDialogLine(
        l10n.movementMovedCount(result.movedCount),
        tone: StatusTone.success,
      ),
      if (result.unknownEpcs.isNotEmpty)
        MessageDialogLine(
          l10n.movementUnknownTags(result.unknownEpcs.length),
          tone: StatusTone.warning,
        ),
      if (result.notInSource.isNotEmpty)
        MessageDialogLine(
          l10n.movementNotInSource(result.notInSource.length),
          tone: StatusTone.warning,
        ),
      if (result.alreadyHere.isNotEmpty)
        MessageDialogLine(l10n.movementAlreadyHere(result.alreadyHere.length)),
      if (result.blocked.isNotEmpty)
        MessageDialogLine(
          l10n.movementBlocked(result.blocked.length),
          tone: StatusTone.danger,
        ),
      if (result.message case final message? when message.isNotEmpty)
        MessageDialogLine(message),
    ],
  );
}

Future<void> showTransferFailedDialog(BuildContext context, Failure failure) {
  final l10n = context.l10n;
  return showMessageDialog(
    context,
    title: l10n.movementFailedTitle,
    tone: StatusTone.danger,
    lines: [MessageDialogLine(failure.localizedMessage(l10n))],
  );
}
