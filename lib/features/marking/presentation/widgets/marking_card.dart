import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/core/l10n/l10n.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/core/widgets/list_card.dart';
import 'package:rfid/core/widgets/status_badge.dart';
import 'package:rfid/features/marking/domain/entities/marking.dart';

/// A marking in the list; opens its tasks.
class MarkingCard extends StatelessWidget {
  const MarkingCard({super.key, required this.marking});

  final Marking marking;

  @override
  Widget build(BuildContext context) {
    return ListCard(
      title: marking.name,
      subtitle: [marking.type, marking.code]
          .where((part) => part.isNotEmpty)
          .join(' · '),
      details: [
        marking.responsiblePerson,
        if (marking.createdAt.isNotEmpty)
          context.l10n.commonCreatedAt(marking.createdAt),
      ],
      trailing:
          marking.status.isEmpty ? null : StatusBadge(label: marking.status),
      onTap: () => context.push(AppRoutes.markingTasks(marking.id)),
    );
  }
}
