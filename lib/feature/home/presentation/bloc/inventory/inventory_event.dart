part of 'inventory_bloc.dart';

sealed class InventoryEvent extends Equatable {}

final class InitialInventoryEvent extends InventoryEvent {
  @override
  List<Object?> get props => [];
}
