import 'package:equatable/equatable.dart';

class BaseState<BUILDABLE, LISTENABLE> extends Equatable {
  const BaseState({this.buildable, this.listenable});

  final BUILDABLE? buildable;
  final LISTENABLE? listenable;

  @override
  List<Object?> get props => [buildable, listenable];

  @override
  bool? get stringify => true;
}
