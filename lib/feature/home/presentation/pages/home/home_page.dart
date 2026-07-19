import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/presentation/router/route_names.dart';

part 'mixin/home_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: InkWell(
            onTap: () {
              context.pushNamed(Routes.products);
            },
            child: const Text('Главная'),
          ),
        ),
      );
}
