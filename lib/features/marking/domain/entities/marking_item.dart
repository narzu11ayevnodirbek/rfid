import 'package:equatable/equatable.dart';

/// An item that needs a tag.
class MarkingItem extends Equatable {
  const MarkingItem({
    required this.id,
    required this.name,
    required this.inventoryNumber,
    required this.status,
    required this.photoPath,
    required this.boundEpc,
  });

  final String id;
  final String name;
  final String inventoryNumber;
  final String status;
  final String photoPath;

  /// EPC of the tag bound to the item; empty while it has none.
  final String boundEpc;

  bool get isBound => boundEpc.isNotEmpty;

  MarkingItem withBoundEpc(String epc) => MarkingItem(
        id: id,
        name: name,
        inventoryNumber: inventoryNumber,
        status: status,
        photoPath: photoPath,
        boundEpc: epc,
      );

  @override
  List<Object?> get props =>
      [id, name, inventoryNumber, status, photoPath, boundEpc];
}
