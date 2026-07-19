import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rf_id_test/core/l10n/app_localizations.dart';

import '../router/app_routes.dart';
import 'bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => KeyboardDismisser(
          child: MaterialApp.router(
            title: 'Rf Id Inventory',

            debugShowCheckedModeBanner: false,
            // themeMode: state.themeMode,
            themeMode: ThemeMode.light,
            theme: state.lightTheme,
            darkTheme: state.darkTheme,
            routerConfig: router,

            /// app language
            locale: switch (state.appLocale) {
              'uz-uz' => const Locale('uz', 'UZ'),
              'ru' => const Locale('ru', 'RU'),
              String() => null,
              null => null,
            },
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: EasyLoading.init(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!,
              ),
            ),
          ),
        ),
      );
}
