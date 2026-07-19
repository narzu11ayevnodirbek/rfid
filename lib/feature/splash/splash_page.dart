import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rf_id_test/injector_container.dart';
import 'package:rf_id_test/router/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go(
          localSource.getUserToken.isNotEmpty ? Routes.inventory : Routes.auth);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Image.asset('assets/logo/app_logo.png',
              width: 200, height: 200, fit: BoxFit.cover),
        ),
      );
}
