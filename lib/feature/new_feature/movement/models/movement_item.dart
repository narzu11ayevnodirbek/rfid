class MovementItem {
  MovementItem({
    required this.id,
    required this.name,
    required this.movementNumber,
    required this.status,
    required this.photo,
    required this.rfid,

    required this.movementId
  });

  factory MovementItem.fromJson(Map<String, dynamic> json, {required String movementId}) => MovementItem(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    movementNumber: json['movement_number'] ?? '',
    status: json['status'] ?? '',
    photo: json['photo'] ?? '',
    rfid: json['rfid'] ?? '',
    movementId: movementId
  );
  final String id;
  final String name;
  final String movementNumber;
  final String status;
  final String photo;
  final String rfid;

  final String movementId;
}
