import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'marking_event.dart';

part 'marking_state.dart';

class MarkingBloc extends Bloc<MarkingEvent, MarkingState> {
  MarkingBloc() : super(MarkingInitial()) {
    on<MarkingEvent>((event, emit) {});
  }
}
