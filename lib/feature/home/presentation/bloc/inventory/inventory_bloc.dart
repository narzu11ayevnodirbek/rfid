import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rf_id_test/core/base/base_functions.dart';
import 'package:rf_id_test/core/constants/constants.dart';
import 'package:rf_id_test/core/enums/status_enums.dart';
import 'package:rf_id_test/core/error/failure.dart';
import 'package:rf_id_test/feature/home/domain/entity/inventory/inventory.dart';
import 'package:rf_id_test/feature/home/domain/use_case/get_list_use_case.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({
    required GetListUseCase getListUseCase,
  })  : _getListUseCase = getListUseCase,
        super(const InventoryState()) {
    on<InitialInventoryEvent>(_initialInventoryEvent);
  }

  final GetListUseCase _getListUseCase;

  FutureOr<void> _initialInventoryEvent(
    InitialInventoryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: PageStatus.loading));
    final result = await _getListUseCase(const GetListParams(
      destination: Urls.inventory,
    ));

    result.fold(
      (e) => emit(state.copyWith(
        status: PageStatus.error,
        message: e is ServerFailure ? e.message : e.message,
      )),
      (r) {
        printLog(r);
        emit(state.copyWith(
          status: PageStatus.success,
          inventoryList: r.map((e) => e as Inventory).toList(),
        ));
      },
    );
  }
}
