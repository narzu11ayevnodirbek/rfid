import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rfid/core/storage/key_value_store.dart';

/// [KeyValueStore] backed by a Hive box in the app documents directory.
class HiveKeyValueStore implements KeyValueStore {
  HiveKeyValueStore._(this._box);

  /// Same box as the legacy app, so an update keeps the user signed in.
  static const String _boxName = 'rf_id_inventory_box';

  static Future<HiveKeyValueStore> open() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    return HiveKeyValueStore._(await Hive.openBox<dynamic>(_boxName));
  }

  final Box<dynamic> _box;

  @override
  String? readString(String key) {
    final value = _box.get(key);
    return value is String ? value : null;
  }

  @override
  Future<void> writeString(String key, String value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);
}
