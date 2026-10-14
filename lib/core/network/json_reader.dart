typedef JsonMap = Map<String, dynamic>;

/// Converts a decoded JSON value to a map or throws a [FormatException].
JsonMap asJsonMap(Object? value) {
  if (value is JsonMap) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw FormatException('Expected a JSON object, got ${value.runtimeType}');
}

/// Reads values from a JSON object without trusting their types.
///
/// The backend is written in PHP and sends the same field as `"12"` in one
/// endpoint and `12` in another, and sometimes `null` or `""` for "no value".
/// Models read every field through this class so a type change on the server
/// cannot crash the app.
class JsonReader {
  const JsonReader(this._json);

  final JsonMap _json;

  /// The value as text, or [fallback] when it is missing or `null`.
  String string(String key, {String fallback = ''}) {
    final value = _json[key];
    return value == null ? fallback : value.toString();
  }

  /// The value as text, or `null` when it is missing, `null` or empty.
  String? stringOrNull(String key) {
    final value = _json[key];
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  /// The first non-empty text among [keys]. Use when a field was renamed
  /// between endpoints (`photo` / `photo_path`).
  String firstString(List<String> keys, {String fallback = ''}) {
    for (final key in keys) {
      final text = stringOrNull(key);
      if (text != null) return text;
    }
    return fallback;
  }

  /// The value as an integer: accepts `12`, `12.0` and `"12"`.
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

  /// The value as a flag: accepts `true`, `1`, `"1"` and `"true"`.
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

  /// A nested object, or `null` when the value is not an object.
  JsonMap? mapOrNull(String key) {
    final value = _json[key];
    return value is Map ? asJsonMap(value) : null;
  }

  /// A list of objects. Anything that is not an object is skipped; a missing
  /// or non-list value gives an empty list.
  List<JsonMap> mapList(String key) {
    final value = _json[key];
    if (value is! List) return const [];
    return [
      for (final element in value)
        if (element is Map) asJsonMap(element),
    ];
  }

  /// A list of texts. `null` elements are skipped.
  List<String> stringList(String key) {
    final value = _json[key];
    if (value is! List) return const [];
    return [
      for (final element in value)
        if (element != null) element.toString(),
    ];
  }

  /// A list whose elements are either objects or plain values, reduced to
  /// text: objects give the first non-empty of [labelKeys].
  ///
  /// The transfer endpoints report problem items this way.
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
