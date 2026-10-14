import 'package:flutter/material.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/features/movement/domain/entities/storage_location.dart';

/// Where the items go.
class LocationPicker extends StatelessWidget {
  const LocationPicker({
    super.key,
    required this.locations,
    required this.selected,
    required this.showRequiredError,
    required this.onSelected,
  });

  final List<StorageLocation> locations;
  final StorageLocation? selected;
  final bool showRequiredError;
  final ValueChanged<StorageLocation> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DropdownButtonFormField<StorageLocation>(
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.movementTargetLocation,
        hintText: l10n.movementSelectLocation,
        prefixIcon: const Icon(Icons.place_outlined),
        errorText: showRequiredError ? l10n.movementLocationRequired : null,
      ),
      items: [
        for (final location in locations)
          DropdownMenuItem(
            value: location,
            child: Text(
              location.displayName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (location) {
        if (location != null) onSelected(location);
      },
    );
  }
}
