import 'package:flutter/material.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';

extension AppSnackbar on BuildContext {
  void showInfoMessage(String message) => _show(message, StatusTone.neutral);

  void showSuccessMessage(String message) => _show(message, StatusTone.success);

  void showErrorMessage(String message) => _show(message, StatusTone.danger);

  void showFailure(Failure failure) =>
      showErrorMessage(failure.localizedMessage(l10n));

  void _show(String message, StatusTone tone) {
    final colors = statusColors;
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: colors.foreground(tone)),
          ),
          backgroundColor: colors.background(tone),
          duration: Duration(seconds: tone == StatusTone.danger ? 4 : 2),
        ),
      );
  }
}
