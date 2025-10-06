part of 'inventory_bloc.dart';

class InventoryState extends Equatable {
  const InventoryState({
    this.status = PageStatus.initial,
    this.inventoryList = const [],
    this.message = '',
  });

  final PageStatus status;
  final List<Inventory> inventoryList;
  final String message;

  InventoryState copyWith({
    final PageStatus? status,
    final List<Inventory>? inventoryList,
    final String? message,
  }) =>
      InventoryState(
        status: status ?? this.status,
        inventoryList: inventoryList ?? this.inventoryList,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [
        status,
        inventoryList,
        message,
      ];
}
