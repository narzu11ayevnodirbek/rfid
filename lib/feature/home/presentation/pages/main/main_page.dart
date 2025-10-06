import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rf_id_test/core/extention/extension.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Theme(
          data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: context.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            selectedIconTheme: IconThemeData(color: context.colorScheme.onSurface),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            type: BottomNavigationBarType.fixed,
            onTap: (index) => widget.navigationShell.goBranch(index),
            items: const [
              BottomNavigationBarItem(
                label: 'Инвентаризация',
                icon: Icon(Icons.inventory_2_outlined),
                activeIcon: Icon(Icons.inventory_2),
              ),
              BottomNavigationBarItem(
                label: 'Маркировка',
                icon: Icon(Icons.local_offer_outlined),
                activeIcon: Icon(Icons.local_offer),
              ),
              BottomNavigationBarItem(
                label: 'Инвентаризация',
                icon: Icon(Icons.swap_horizontal_circle_outlined),
                activeIcon: Icon(Icons.swap_horizontal_circle),
              ),
            ],
          ),
        ),
      );
}
