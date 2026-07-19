import 'package:rfid/feature/home/data/dto/get_list_model/get_list_model.dart';

class OpenInventoryDto extends GetListModel {
  OpenInventoryDto({
    this.id,
    this.name,
    this.inventoryNumber,
    this.serialNumber,
    this.cost,
    this.location,
    this.discoveryDate,
  });

  factory OpenInventoryDto.fromJson(Map<String, dynamic> json) => OpenInventoryDto(
        id: json['id'] as String?,
        name: json['name'] as String?,
        inventoryNumber: json['inventory_number'] as String?,
        serialNumber: json['serial_number'] as String?,
        cost: json['cost'] as String?,
        location: json['location'] as String?,
        discoveryDate: json['discovery_date'] as String?,
      );

  final String? id;
  final String? name;
  final String? inventoryNumber;
  final String? serialNumber;
  final String? cost;
  final String? location;
  final String? discoveryDate;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inventory_number': inventoryNumber,
        'serial_number': serialNumber,
        'cost': cost,
        'location': location,
        'discovery_date': discoveryDate,
      };
}
