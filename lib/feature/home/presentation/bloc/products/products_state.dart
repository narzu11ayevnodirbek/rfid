part of 'products_bloc.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.status = PageStatus.initial,
    this.productsList = const [],
    this.isEnd = false,
    this.filter = const ProductsFilter(),
    this.message = '',
  });

  final PageStatus status;
  final List<Products> productsList;
  final bool isEnd;
  final ProductsFilter filter;
  final String message;

  ProductsState copyWith({
    final PageStatus? status,
    final List<Products>? productsList,
    final bool? isEnd,
    final ProductsFilter? filter,
    final String? message,
  }) =>
      ProductsState(
        status: status ?? this.status,
        productsList: productsList ?? this.productsList,
        filter: filter ?? this.filter,
        isEnd: isEnd ?? this.isEnd,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [status, productsList, isEnd, filter, message];
}
