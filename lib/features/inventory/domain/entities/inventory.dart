import 'package:equatable/equatable.dart';

/// An inventory count assigned to the user: which items are where.
class Inventory extends Equatable {
  const Inventory({
    required this.id,
    required this.name,
    required this.type,
    required this.responsibleName,
    required this.createdAt,
    required this.statusCode,
    required this.statusLabel,
    required this.foundCount,
    required this.missingCount,
    required this.totalCount,
  });

  final String id;

  /// Usually the inventory number, shown as "Inventory No {name}".
  final String name;
  final String type;
  final String responsibleName;

  /// As sent by the server (`2025-10-06 12:00:00`).
  final String createdAt;

  /// Machine-readable status, for example `closed`.
  final String statusCode;

  /// Status in words, as the server phrases it.
  final String statusLabel;
  final int foundCount;
  final int missingCount;
  final int totalCount;

  bool get isClosed => statusCode == 'closed';

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        responsibleName,
        createdAt,
        statusCode,
        statusLabel,
        foundCount,
        missingCount,
        totalCount,
      ];
}
