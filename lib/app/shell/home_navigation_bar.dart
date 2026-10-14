import 'package:flutter/material.dart';
import 'package:rfid/core/theme/app_spacing.dart';

class HomeNavigationDestination {
  const HomeNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Labels always stay on one line, so every tab keeps the same height with
/// long words or a large system font.
class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const double height = 72;

  final List<HomeNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (final (index, destination) in destinations.indexed)
                Expanded(
                  child: _HomeNavigationItem(
                    destination: destination,
                    isSelected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeNavigationItem extends StatelessWidget {
  const _HomeNavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final HomeNavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final iconColor =
        isSelected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;
    final labelStyle = theme.textTheme.labelMedium!.copyWith(
      color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
    );
    final textScaler = MediaQuery.textScalerOf(context).clamp(
      maxScaleFactor: 1.3,
    );
    final labelHeight =
        textScaler.scale(labelStyle.fontSize!) * (labelStyle.height ?? 1.2);

    return Semantics(
      button: true,
      selected: isSelected,
      label: destination.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      isSelected ? scheme.primaryContainer : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Icon(
                  isSelected ? destination.selectedIcon : destination.icon,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                height: labelHeight,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      destination.label,
                      maxLines: 1,
                      textScaler: textScaler,
                      style: labelStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
