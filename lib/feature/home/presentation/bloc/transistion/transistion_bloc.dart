import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transistion_event.dart';
part 'transistion_state.dart';

class TransistionBloc extends Bloc<TransistionEvent, TransistionState> {
  TransistionBloc() : super(TransistionInitial()) {
    on<TransistionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
