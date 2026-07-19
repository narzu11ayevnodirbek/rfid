import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rfid/core/constants/constants.dart';
import 'package:rfid/infrastructure/enums/status_enums.dart';
import 'package:rfid/domain/failures/failure.dart';
import 'package:rfid/feature/home/domain/entity/products/products.dart';
import 'package:rfid/feature/home/domain/entity/products/products_filter.dart';
import 'package:rfid/feature/home/domain/use_case/get_list_use_case.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({required GetListUseCase getListUseCase})
      : _getListUseCase = getListUseCase,
        super(const ProductsState()) {
    on<InitialProductsEvent>(_initialProductsEvent);
    on<AddListProductsEvent>(_addListProductsEvent);
  }

  final GetListUseCase _getListUseCase;

  bool addListLoading = true;

  FutureOr<void> _initialProductsEvent(
    InitialProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: PageStatus.loading));
    final result = await _getListUseCase(GetListParams(
      destination: Urls.products,
      queryParameters: state.filter.toJson(),
    ));

    result.fold(
      (e) => emit(state.copyWith(
        status: PageStatus.error,
        message: e is ServerFailure ? e.message : e.message,
      )),
      (r) {
        emit(state.copyWith(
          status: PageStatus.success,
          productsList: r.map((e) => e as Products).toList(),
          isEnd: r.length < 20,
        ));
      },
    );
  }

  FutureOr<void> _addListProductsEvent(
    AddListProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    addListLoading = true;
    emit(state.copyWith(
      filter: state.filter.copyWith(offset: state.filter.offset + 1),
    ));
    final result = await _getListUseCase(GetListParams(
      destination: Urls.products,
      queryParameters: state.filter.toJson(),
    ));

    result.fold(
      (e) => emit(state.copyWith(
        status: PageStatus.error,
        message: e is ServerFailure ? e.message : e.message,
      )),
      (r) {
        final newProductsList = r.map((e) => e as Products).toList();
        emit(state.copyWith(
          status: PageStatus.success,
          productsList: [...state.productsList, ...newProductsList],
          isEnd: r.length < 20,
        ));
      },
    );
    addListLoading = false;
  }
}
