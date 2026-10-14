import 'package:equatable/equatable.dart';

class MovementTask extends Equatable {
  const MovementTask({
    required this.id,
    required this.movementId,
    required this.name,
    required this.status,
    required this.sourceLocation,
    required this.destination,
    required this.executorName,
    required this.createdAt,
    required this.movedCount,
    required this.totalCount,
  });

  final String id;

  final String movementId;
  final String name;
  final String status;
  final String sourceLocation;
  final String destination;
  final String executorName;
  final String createdAt;
  final int movedCount;
  final int totalCount;

  @override
  List<Object?> get props => [
        id,
        movementId,
        name,
        status,
        sourceLocation,
        destination,
        executorName,
        createdAt,
        movedCount,
        totalCount,
      ];
}
