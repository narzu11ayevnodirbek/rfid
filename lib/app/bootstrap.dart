import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rfid/app/di/service_locator.dart';
import 'package:rfid/app/rfid_app.dart';
import 'package:rfid/core/config/app_config.dart';
import 'package:rfid/core/network/api_host_certificate_override.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';
import 'package:rfid/features/settings/presentation/bloc/settings_bloc.dart';

Future<void> bootstrap() async {
  if (!AppConfig.isConfigured) {
    throw StateError(
      'API_BASE_URL is not set. Run with --dart-define-from-file=.env '
      '(copy .env.example to .env first).',
    );
  }
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.trustApiHostCertificate) {
    HttpOverrides.global = ApiHostCertificateOverride(AppConfig.apiHost);
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await setUpServiceLocator();

  runApp(
    RfidApp(
      // The saved session is restored here, so the first screen is already
      // the right one (login or inventory) and no splash screen is needed.
      sessionBloc: SessionBloc(storage: sl(), repository: sl()),
      settingsBloc: SettingsBloc(sl()),
    ),
  );
}
