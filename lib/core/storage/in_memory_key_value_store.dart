import 'package:rfid/core/storage/key_value_store.dart';

/// [KeyValueStore] that forgets everything when the app closes.
///
/// Used by tests and by widget previews that must not touch the disk.
class InMemoryKeyValueStore implements KeyValueStore {
  InMemoryKeyValueStore([Map<String, String>? initial])
      : _values = {...?initial};

  final Map<String, String> _values;

  @override
  String? readString(String key) => _values[key];

  @override
  Future<void> writeString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }
}
