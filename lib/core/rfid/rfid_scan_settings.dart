/// Reader power for each kind of scan, in dBm (the module accepts 5–30).
///
/// Higher power reads tags further away: good for counting a whole room,
/// bad for picking one item out of a shelf. Tune the values here; every
/// scan screen uses its profile when it starts the reader.
enum RfidPowerProfile {
  /// Count everything in the room.
  inventory(30),

  /// Collect the items being moved, not the whole shelf around them.
  movement(18),

  /// Read the one tag held next to the device.
  marking(15),

  /// Identify the item in front of the device.
  itemLookup(15),

  /// Default for the diagnostics screen; the slider changes it.
  diagnostics(26);

  const RfidPowerProfile(this.dbm);

  final int dbm;
}

/// Behaviour switches for the hardware reader.
abstract final class RfidScanSettings {
  static const int minPowerDbm = 5;
  static const int maxPowerDbm = 30;

  /// `true`: pressing "Start" begins reading at once; the hardware trigger
  /// also works. `false`: "Start" only arms the trigger and tags are read
  /// while the trigger is held.
  ///
  /// `true` matches the latest behaviour of the legacy app. Check both on the
  /// device (Settings → Reader diagnostics) and keep the one operators prefer.
  static const bool readImmediatelyOnStart = true;
}
