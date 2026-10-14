import 'package:flutter/material.dart';
import 'package:rfid/core/config/app_config.dart';
import 'package:rfid/core/theme/app_spacing.dart';

class ItemPhoto extends StatelessWidget {
  const ItemPhoto({super.key, required this.path, this.height = 200});

  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Icon(
      Icons.image_not_supported_outlined,
      size: 48,
      color: scheme.outline,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: height,
        width: double.infinity,
        color: scheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: path.isEmpty
            ? placeholder
            : Image.network(
                AppConfig.resolveFileUrl(path),
                height: height,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const CircularProgressIndicator(),
                errorBuilder: (_, __, ___) => Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: scheme.outline,
                ),
              ),
      ),
    );
  }
}
