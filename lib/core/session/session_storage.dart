import 'dart:async';
import 'dart:convert';

import 'package:rfid/core/session/user.dart';
import 'package:rfid/core/storage/key_value_store.dart';

enum SessionEndReason { signedOut, expired }

class SessionStorage {
  SessionStorage(this._store) {
    _token = _store.readString(_tokenKey);
    _user = _decodeUser(_store.readString(_userKey));
  }

  // Same key as the legacy app, so an update keeps the user signed in.
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  final KeyValueStore _store;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  String? _token;
  User? _user;
  SessionEndReason? _lastEndReason;

  String? get token => _token;

  User? get user => _user;

  bool get isAuthenticated => (_token ?? '').isNotEmpty;

  SessionEndReason? get lastEndReason => _lastEndReason;

  Stream<void> get changes => _changes.stream;

  Future<void> start({required String token, required User user}) async {
    _token = token;
    _user = user;
    _lastEndReason = null;
    await _store.writeString(_tokenKey, token);
    await _store.writeString(_userKey, _encodeUser(user));
    _changes.add(null);
  }

  Future<void> end() => _clear(SessionEndReason.signedOut);

  /// Ignored when [rejectedToken] is no longer current: a late 401 from a
  /// previous session must not sign out the user who has just signed in.
  Future<void> expire(String rejectedToken) async {
    if (rejectedToken != _token) return;
    await _clear(SessionEndReason.expired);
  }

  Future<void> _clear(SessionEndReason reason) async {
    if (!isAuthenticated) return;
    _token = null;
    _user = null;
    _lastEndReason = reason;
    await _store.delete(_tokenKey);
    await _store.delete(_userKey);
    _changes.add(null);
  }

  static String _encodeUser(User user) => jsonEncode({
        'id': user.id,
        'login': user.login,
        'username': user.username,
      });

  static User? _decodeUser(String? source) {
    if (source == null) return null;
    try {
      final json = jsonDecode(source);
      if (json is! Map) return null;
      return User(
        id: '${json['id'] ?? ''}',
        login: '${json['login'] ?? ''}',
        username: '${json['username'] ?? ''}',
      );
    } on FormatException {
      return null;
    }
  }
}
