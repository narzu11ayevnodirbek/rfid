import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/core/session/user.dart';
import 'package:rfid/core/storage/in_memory_key_value_store.dart';

const _user = User(id: '7', login: 'operator', username: 'Operator');

void main() {
  late InMemoryKeyValueStore store;

  setUp(() => store = InMemoryKeyValueStore());

  test('starts signed out on a fresh install', () {
    final session = SessionStorage(store);

    expect(session.isAuthenticated, isFalse);
    expect(session.token, isNull);
    expect(session.user, isNull);
  });

  test('persists the session so the next launch restores it', () async {
    await SessionStorage(store).start(token: 'abc', user: _user);

    final restored = SessionStorage(store);

    expect(restored.isAuthenticated, isTrue);
    expect(restored.token, 'abc');
    expect(restored.user, _user);
  });

  test('restores a legacy install that stored only the token', () {
    final session = SessionStorage(
      InMemoryKeyValueStore({'auth_token': 'legacy'}),
    );

    expect(session.isAuthenticated, isTrue);
    expect(session.user, isNull);
  });

  test('announces sign-in and sign-out', () async {
    final session = SessionStorage(store);
    var changes = 0;
    session.changes.listen((_) => changes++);

    await session.start(token: 'abc', user: _user);
    await session.end();
    await pumpEventQueue();

    expect(changes, 2);
    expect(session.isAuthenticated, isFalse);
    expect(session.lastEndReason, SessionEndReason.signedOut);
    expect(SessionStorage(store).isAuthenticated, isFalse);
  });

  test('expires only when the rejected token is the current one', () async {
    final session = SessionStorage(store);
    await session.start(token: 'new', user: _user);

    await session.expire('old');
    expect(session.isAuthenticated, isTrue);

    await session.expire('new');
    expect(session.isAuthenticated, isFalse);
    expect(session.lastEndReason, SessionEndReason.expired);
  });

  test('ending a session twice announces it once', () async {
    final session = SessionStorage(store);
    await session.start(token: 'abc', user: _user);
    var changes = 0;
    session.changes.listen((_) => changes++);

    await session.end();
    await session.end();
    await pumpEventQueue();

    expect(changes, 1);
  });
}
