enum RfidMode {
  none,
  inventory,
  marking,
  movement,
  bindRfid, // привязка метки к объекту (новые объекты)
}

class RfidSession {
  RfidSession._();

  static final RfidSession _instance = RfidSession._();

  static RfidSession get instance => _instance;

  RfidMode currentMode = RfidMode.none;
}
