enum RfidMode { none, inventory, marking, movement, bindRfid }

class RfidSession {
  RfidSession._();

  static final RfidSession _instance = RfidSession._();

  static RfidSession get instance => _instance;

  RfidMode currentMode = RfidMode.none;
}
