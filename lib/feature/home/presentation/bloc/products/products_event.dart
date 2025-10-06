part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();
}

final class InitialProductsEvent extends ProductsEvent {
  @override
  List<Object?> get props => [];
}

final class AddListProductsEvent extends ProductsEvent {
  @override
  List<Object?> get props => [];
}
