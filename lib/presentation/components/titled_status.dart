import 'package:flutter/material.dart';
import 'package:rfid/core/extension/extension.dart';

class TitledStatus extends StatelessWidget {
  const TitledStatus({
    super.key,
    this.title = 'Состояние',
    required this.status,
  });

  final String title;
  final String status;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textStyle.regularHeadline.copyWith(fontSize: 12)),
          4.kBoxHeight,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: 12.kBorderRadiusAll,
              color: _getStatusColor(context),
            ),
            child: Text(
              _getStatusName(),
              style: context.textStyle.regularCallout.copyWith(
                fontSize: 14,
                color: _getStatusTextColor(context),
              ),
            ),
          ),
        ],
      );

  Color _getStatusColor(BuildContext context) => switch (status) {
        'pending' => Colors.orange,
        'inactive' => Colors.grey,
        String() => context.colorScheme.primary,
      };

  Color _getStatusTextColor(BuildContext context) => switch (status) {
        'pending' => Colors.white,
        'inactive' => Colors.white,
        String() => Colors.white,
      };

  String _getStatusName() => switch (status) {
        'pending' => 'Назначена',
        'inactive' => 'Неактивный',
        String() => 'В подготовке',
      };
}
