import 'package:equatable/equatable.dart';
import 'package:rfid/features/marking/domain/entities/marking_item.dart';

class MarkingTask extends Equatable {
  const MarkingTask({
    required this.id,
    required this.markingId,
    required this.name,
    required this.status,
    required this.executorName,
    required this.items,
  });

  final String id;
  final String markingId;
  final String name;
  final String status;
  final String executorName;
  final List<MarkingItem> items;

  int get totalCount => items.length;

  int get boundCount => items.where((item) => item.isBound).length;

  MarkingItem? findItem(String itemId) {
    for (final item in items) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  @override
  List<Object?> get props => [id, markingId, name, status, executorName, items];
}
