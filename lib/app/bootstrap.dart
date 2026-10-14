import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rfid/app/di/service_locator.dart';
import 'package:rfid/app/rfid_app.dart';
import 'package:rfid/core/config/app_config.dart';
import 'package:rfid/core/network/api_host_certificate_override.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';
import 'package:rfid/features/settings/presentation/bloc/settings_bloc.dart';

/// Everything that has to happen before the first frame.
Future<void> bootstrap() async {
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
