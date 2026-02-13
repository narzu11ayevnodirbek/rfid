import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/rfid/rfid_controller.dart';

import 'app/app.dart';
import 'app/bloc/app_bloc.dart';
import 'feature/new_feature/inventory/controllers/inventory_controller.dart';
import 'injector_container.dart' as di;
import 'injector_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(RfidController(), permanent: true);

  await di.init();

  Get.put<InventoryController>(
    InventoryController(),
    permanent: true,
  );

  Get.put<RfidController>(
    RfidController(),
    permanent: true,
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).whenComplete(() {
    runApp(const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        transitionDuration: Duration(milliseconds: 300),
        home: MyApp()));
  });
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(create: (_) => sl<AppBloc>()),
        ],
        child: const App(),
      );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 2)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = true
    ..dismissOnTap = false;
}
