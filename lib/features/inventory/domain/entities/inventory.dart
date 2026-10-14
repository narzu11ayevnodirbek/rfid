import 'package:equatable/equatable.dart';

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

  final String name;
  final String type;
  final String responsibleName;

  final String createdAt;

  final String statusCode;

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
