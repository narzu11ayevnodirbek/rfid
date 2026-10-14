import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/l10n/l10n.dart';

extension FailureLocalizer on Failure {
  String localizedMessage(AppLocalizations l10n) => switch (this) {
        NetworkFailure() => l10n.failureNetwork,
        UnauthorizedFailure() => l10n.failureUnauthorized,
        ServerFailure(:final message?) when message.isNotEmpty => message,
        ServerFailure(:final statusCode?) when statusCode >= 400 =>
          l10n.failureServerWithCode(statusCode),
        ServerFailure() => l10n.failureServer,
        ParsingFailure() => l10n.failureParsing,
        RfidFailure(:final reason) => switch (reason) {
            RfidFailureReason.unavailable => l10n.failureRfidUnavailable,
            RfidFailureReason.initFailed => l10n.failureRfidInitFailed,
            RfidFailureReason.commandFailed => l10n.failureRfidCommandFailed,
          },
        UnexpectedFailure() => l10n.failureUnexpected,
      };
}
