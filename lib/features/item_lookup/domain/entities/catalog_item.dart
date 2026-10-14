import 'package:equatable/equatable.dart';

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

  final String code;
  final String location;
  final String responsible;

  final String epc;
  final String photoPath;

  @override
  List<Object?> get props =>
      [id, name, code, location, responsible, epc, photoPath];
}
