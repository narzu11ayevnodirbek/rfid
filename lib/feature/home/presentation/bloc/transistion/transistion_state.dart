part of 'transistion_bloc.dart';

sealed class TransistionState extends Equatable {
  const TransistionState();
}

final class TransistionInitial extends TransistionState {
  @override
  List<Object> get props => [];
}
