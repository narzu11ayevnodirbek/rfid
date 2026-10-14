/// Reader power in dBm (5–30) for each kind of scan.
enum RfidPowerProfile {
  inventory(30),
  movement(18),
  marking(15),
  itemLookup(15),
  diagnostics(26);

  const RfidPowerProfile(this.dbm);

  final int dbm;
}

abstract final class RfidScanSettings {
  static const int minPowerDbm = 5;
  static const int maxPowerDbm = 30;

  /// true: "Start" begins reading at once (the trigger works too).
  /// false: "Start" only arms the trigger; tags are read while it is held.
  static const bool readImmediatelyOnStart = true;
}
