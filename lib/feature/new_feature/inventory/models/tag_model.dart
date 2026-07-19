class TagModel {
  TagModel({
    required this.price,
    required this.statusFilter,
    required this.location,
    required this.responsible,
    required this.createdAt,
    required this.id,
    required this.name,
    required this.code,
    required this.hasRfid,
    required this.imageUrl,
    required this.rfid,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        code: json['code'] ?? '',
        hasRfid: json['has_rfid'].toString() == '1',
        price: json['price'] ?? '',
        statusFilter: json['status'] ?? '',
        location: json['location'] ?? '',
        responsible: json['responsible'] ?? '',
        createdAt: json['created_at'] ?? '',
        imageUrl: json['photo_path'] ?? '',
        rfid: json['rfid']?.toString() ?? '',
      );

  final String id;
  final String name;
  final String price;
  final String statusFilter;
  final String location;
  final String responsible;
  final String createdAt;
  final String code;
  final bool hasRfid;
  final String imageUrl;
  final String rfid;

  String get data => '$name ($code)';

  String get status => hasRfid ? 'Считано' : 'Не найдено';
}
