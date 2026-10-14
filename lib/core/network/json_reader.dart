typedef JsonMap = Map<String, dynamic>;

JsonMap asJsonMap(Object? value) {
  if (value is JsonMap) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw FormatException('Expected a JSON object, got ${value.runtimeType}');
}

/// The PHP backend sends the same field as "12", 12 or null. Models read
/// every field through this class so a type change cannot crash the app.
class JsonReader {
  const JsonReader(this._json);

  final JsonMap _json;

  String string(String key, {String fallback = ''}) {
    final value = _json[key];
    return value == null ? fallback : value.toString();
  }

  String? stringOrNull(String key) {
    final value = _json[key];
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  String firstString(List<String> keys, {String fallback = ''}) {
    for (final key in keys) {
      final text = stringOrNull(key);
      if (text != null) return text;
    }
    return fallback;
  }

  int integer(String key, {int fallback = 0}) => integerOrNull(key) ?? fallback;

  int? integerOrNull(String key) {
    final value = _json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final text = value.trim();
      return int.tryParse(text) ?? double.tryParse(text)?.toInt();
    }
    return null;
  }

  bool boolean(String key) {
    final value = _json[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final text = value.trim().toLowerCase();
      return text == '1' || text == 'true';
    }
    return false;
  }

  JsonMap? mapOrNull(String key) {
    final value = _json[key];
    return value is Map ? asJsonMap(value) : null;
  }

  List<JsonMap> mapList(String key) {
    final value = _json[key];
    if (value is! List) return const [];
    return [
      for (final element in value)
        if (element is Map) asJsonMap(element),
    ];
  }

  List<String> stringList(String key) {
    final value = _json[key];
    if (value is! List) return const [];
    return [
      for (final element in value)
        if (element != null) element.toString(),
    ];
  }

  List<String> labelList(String key, {required List<String> labelKeys}) {
    final value = _json[key];
    if (value is! List) return const [];
    return [
      for (final element in value)
        if (element is Map)
          JsonReader(asJsonMap(element)).firstString(labelKeys)
        else if (element != null)
          element.toString(),
    ];
  }
}
