import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/l10n/failure_localizer.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_colors.dart';
import 'package:rfid/core/theme/app_spacing.dart';
import 'package:rfid/features/auth/presentation/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<LoginBloc>();

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isSubmitting = state.status == LoginStatus.submitting;
        final failure = state.failure;

        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                enabled: !isSubmitting,
                autofillHints: const [AutofillHints.username],
                textInputAction: TextInputAction.next,
                onChanged: (value) => bloc.add(LoginLoginChanged(value)),
                decoration: InputDecoration(
                  labelText: l10n.loginLoginLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: state.showValidationErrors && state.isLoginMissing
                      ? l10n.loginFieldRequired
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                enabled: !isSubmitting,
                obscureText: !state.isPasswordVisible,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onChanged: (value) => bloc.add(LoginPasswordChanged(value)),
                onSubmitted: (_) => bloc.add(const LoginSubmitted()),
                decoration: InputDecoration(
                  labelText: l10n.loginPasswordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  errorText:
                      state.showValidationErrors && state.isPasswordMissing
                          ? l10n.loginFieldRequired
                          : null,
                  suffixIcon: IconButton(
                    tooltip: state.isPasswordVisible
                        ? l10n.loginHidePassword
                        : l10n.loginShowPassword,
                    onPressed: () =>
                        bloc.add(const LoginPasswordVisibilityToggled()),
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              if (failure != null && state.status == LoginStatus.failure) ...[
                const SizedBox(height: AppSpacing.md),
                _LoginFailureText(failure: failure),
              ],
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: isSubmitting
                    ? null
                    : () => bloc.add(const LoginSubmitted()),
                child: isSubmitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Text(l10n.loginSubmit),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoginFailureText extends StatelessWidget {
  const _LoginFailureText({required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = switch (failure) {
      UnauthorizedFailure() => l10n.loginInvalidCredentials,
      _ => failure.localizedMessage(l10n),
    };
    return Text(
      message,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.statusColors.foreground(StatusTone.danger),
          ),
    );
  }
}
