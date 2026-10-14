import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/confirm_dialog.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';
import 'package:rfid/features/settings/presentation/widgets/account_card.dart';
import 'package:rfid/features/settings/presentation/widgets/language_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: AppSpacing.list,
        children: [
          const AccountCard(),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.settingsLanguage, style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          const LanguageSelector(),
          const SizedBox(height: AppSpacing.xl),
          ListCard(
            leading: const Icon(Icons.sensors),
            title: l10n.settingsReaderDiagnostics,
            subtitle: l10n.settingsReaderDiagnosticsSubtitle,
            onTap: () => context.push(AppRoutes.readerDiagnostics),
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            icon: const Icon(Icons.logout),
            label: Text(l10n.settingsSignOut),
            onPressed: () => confirmThen(
              context,
              title: l10n.settingsSignOutTitle,
              message: l10n.settingsSignOutMessage,
              confirmLabel: l10n.settingsSignOutConfirm,
              isDestructive: true,
              onConfirmed: () => context
                  .read<SessionBloc>()
                  .add(const SessionSignOutRequested()),
            ),
          ),
        ],
      ),
    );
  }
}
