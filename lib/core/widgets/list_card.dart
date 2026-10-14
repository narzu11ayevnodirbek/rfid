import 'package:flutter/material.dart';
import 'package:rfid/core/theme/app_spacing.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.details = const [],
    this.leading,
    this.trailing,
    this.footer,
    this.onTap,
  });

  final String title;
  final String? subtitle;

  final List<String> details;
  final Widget? leading;

  final Widget? trailing;
  final Widget? footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final trailingWidget = trailing ??
        (onTap == null ? null : Icon(Icons.chevron_right, color: muted));

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(color: muted),
                      ),
                    ],
                    for (final line in details)
                      if (line.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xxs),
                          child: Text(
                            line,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: muted),
                          ),
                        ),
                    if (footer != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      footer!,
                    ],
                  ],
                ),
              ),
              if (trailingWidget != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailingWidget,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
