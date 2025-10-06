part of 'marking_bloc.dart';

sealed class MarkingState extends Equatable {
  const MarkingState();
}

final class MarkingInitial extends MarkingState {
  @override
  List<Object> get props => [];
}
