import 'package:equatable/equatable.dart';

class ProductsFilter extends Equatable {
  const ProductsFilter({
    this.location = '',
    this.status = ProductsStatus.all,
    this.limit = 20,
    this.offset = 1,
  });

  final String location;
  final ProductsStatus status;
  final int limit;
  final int offset;

  ProductsFilter copyWith({
    final String? location,
    final ProductsStatus? status,
    final int? limit,
    final int? offset,
  }) =>
      ProductsFilter(
        location: location ?? this.location,
        status: status ?? this.status,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
      );

  Map<String, dynamic> toJson() => {
        if (location.isNotEmpty) 'location': location,
        'status_filter': status.name,
        'limit': limit,
        'offset': offset,
      };

  @override
  List<Object?> get props => [location, status, limit, offset];
}

enum ProductsStatus {
  all,
  in_place,
  moved,
  unknown,
  removed,
}
