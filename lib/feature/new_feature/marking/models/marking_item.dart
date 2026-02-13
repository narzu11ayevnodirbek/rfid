class MarkingItem {
  MarkingItem({
    required this.id,
    required this.name,
    required this.markingNumber,
    required this.status,
    required this.photo,
    required this.rfid,
    required this.markingId,
    required this.taskId,
  });

  factory MarkingItem.fromJson(Map<String, dynamic> json, {
    required String markingId,
    required String taskId,
  }) => MarkingItem(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    markingNumber: json['inventory_number'] ?? '',
    status: json['status'] ?? '',
    photo: json['photo'] ?? '',
    rfid: json['rfid'] ?? '',
    markingId: markingId,
    taskId: taskId,
  );
  final String id;
  final String name;
  final String markingNumber;
  final String status;
  final String photo;
  final String rfid;

  final String markingId;
  final String taskId;
}
