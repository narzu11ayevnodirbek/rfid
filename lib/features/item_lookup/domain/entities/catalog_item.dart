import 'package:equatable/equatable.dart';

/// An item of the asset catalogue.
class CatalogItem extends Equatable {
  const CatalogItem({
    required this.id,
    required this.name,
    required this.code,
    required this.location,
    required this.responsible,
    required this.epc,
    required this.photoPath,
  });

  final String id;
  final String name;

  /// Inventory number or barcode.
  final String code;
  final String location;
  final String responsible;

  /// Normalized EPC of the item's tag; empty when the item has no tag.
  final String epc;
  final String photoPath;

  @override
  List<Object?> get props =>
      [id, name, code, location, responsible, epc, photoPath];
}
