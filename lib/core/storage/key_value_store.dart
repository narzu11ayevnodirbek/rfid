/// Small persistent storage for settings, the session and drafts.
///
/// The rest of the app depends on this interface, not on Hive, so the storage
/// engine can be replaced in one place and faked in tests.
abstract interface class KeyValueStore {
  String? readString(String key);

  Future<void> writeString(String key, String value);

  Future<void> delete(String key);
}
