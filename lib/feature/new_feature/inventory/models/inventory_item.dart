class InventoryItem {
  InventoryItem({
    required this.id,
    required this.name,
    required this.inventoryNumber,
    required this.status,
    required this.photo,
    required this.rfid,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        inventoryNumber: json['inventory_number'] ?? '',
        status: json['status'] ?? '',
        photo: json['photo'] ?? '',
        rfid: json['rfid'] ?? '',
      );
  final String id;
  final String name;
  final String inventoryNumber;
  final String status;
  final String photo;
  final String rfid;
}
