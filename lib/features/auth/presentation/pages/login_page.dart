import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/core/widgets/info_banner.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';
import 'package:rfid/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final sessionExpired = context.select(
      (SessionBloc bloc) => bloc.state.endReason == SessionEndReason.expired,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.page,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/logo/app_logo.png', height: 88),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (sessionExpired) ...[
                    InfoBanner(
                      message: l10n.failureUnauthorized,
                      tone: StatusTone.warning,
                      icon: Icons.lock_clock_outlined,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
