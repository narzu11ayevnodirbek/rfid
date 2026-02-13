import 'dart:async';

class RfidBus {
  RfidBus._();

  static final instance = RfidBus._();

  final _controller = StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void broadcast(String tag) => _controller.add(tag);
}
