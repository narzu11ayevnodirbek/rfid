import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/app/router/app_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/theme/app_theme.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';
import 'package:rfid/features/settings/presentation/bloc/settings_bloc.dart';

/// Root widget: app-wide blocs, theme, language and navigation.
class RfidApp extends StatefulWidget {
  const RfidApp({
    super.key,
    required this.sessionBloc,
    required this.settingsBloc,
  });

  final SessionBloc sessionBloc;
  final SettingsBloc settingsBloc;

  @override
  State<RfidApp> createState() => _RfidAppState();
}

class _RfidAppState extends State<RfidApp> {
  // Created once: rebuilding the router would reset navigation.
  late final GoRouter _router = createAppRouter(widget.sessionBloc);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.sessionBloc),
        BlocProvider.value(value: widget.settingsBloc),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settings) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          locale: settings.language.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        ),
      ),
    );
  }
}
