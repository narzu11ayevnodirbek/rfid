import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/app/shell/home_navigation_bar.dart';
import 'package:rfid/core/l10n/l10n.dart';

class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: HomeNavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the current tab again goes back to its first screen.
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          HomeNavigationDestination(
            icon: Icons.inventory_2_outlined,
            selectedIcon: Icons.inventory_2,
            label: l10n.tabInventory,
          ),
          HomeNavigationDestination(
            icon: Icons.sell_outlined,
            selectedIcon: Icons.sell,
            label: l10n.tabMarking,
          ),
          HomeNavigationDestination(
            icon: Icons.swap_horiz,
            selectedIcon: Icons.swap_horizontal_circle,
            label: l10n.tabMovement,
          ),
          HomeNavigationDestination(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
