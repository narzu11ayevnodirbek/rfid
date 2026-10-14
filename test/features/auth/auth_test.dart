import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/core/session/user.dart';
import 'package:rfid/core/storage/in_memory_key_value_store.dart';
import 'package:rfid/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rfid/features/auth/data/models/login_response_model.dart';
import 'package:rfid/features/auth/data/models/user_model.dart';
import 'package:rfid/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rfid/features/auth/domain/repositories/auth_repository.dart';
import 'package:rfid/features/auth/presentation/bloc/login_bloc.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockAuthRepository extends Mock implements AuthRepository {}

const _user = UserModel(id: '3', login: 'operator', username: 'Operator');

void main() {
  group('LoginResponseModel', () {
    test('reads the token and the user', () {
      final model = LoginResponseModel.fromJson({
        'success': true,
        'token': 'abc',
        'user': {'id': 3, 'login': 'operator', 'username': 'Operator'},
      });

      expect(model.token, 'abc');
      expect(model.user, _user);
    });

    test('refuses a response without a token', () {
      expect(
        () => LoginResponseModel.fromJson({'success': true}),
        throwsFormatException,
      );
    });
  });

  group('AuthRepositoryImpl', () {
    late _MockAuthRemoteDataSource remote;
    late SessionStorage session;
    late AuthRepositoryImpl repository;

    setUp(() {
      remote = _MockAuthRemoteDataSource();
      session = SessionStorage(InMemoryKeyValueStore());
      repository = AuthRepositoryImpl(remote, session);
    });

    test('starts the session after a successful sign-in', () async {
      when(() => remote.login(login: 'operator', password: 'secret'))
          .thenAnswer(
        (_) async => const LoginResponseModel(token: 'abc', user: _user),
      );

      final result = await repository.signIn(
        login: 'operator',
        password: 'secret',
      );

      expect(result.valueOrNull, _user);
      expect(session.token, 'abc');
      expect(session.user, _user);
    });

    test('keeps the user signed out when the server refuses', () async {
      when(() => remote.login(login: 'operator', password: 'bad'))
          .thenThrow(const ApiException(message: 'Неверный пароль'));

      final result = await repository.signIn(
        login: 'operator',
        password: 'bad',
      );

      expect(
        result.failureOrNull,
        const ServerFailure(message: 'Неверный пароль'),
      );
      expect(session.isAuthenticated, isFalse);
    });

    test('sign-out ends the session', () async {
      await session.start(token: 'abc', user: _user);

      await repository.signOut();

      expect(session.isAuthenticated, isFalse);
    });
  });

  group('LoginBloc', () {
    late _MockAuthRepository repository;

    setUp(() => repository = _MockAuthRepository());

    blocTest<LoginBloc, LoginState>(
      'highlights empty fields instead of submitting',
      build: () => LoginBloc(repository),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => const [LoginState(showValidationErrors: true)],
      verify: (_) => verifyNever(
        () => repository.signIn(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ),
    );

    blocTest<LoginBloc, LoginState>(
      'signs in with trimmed credentials',
      setUp: () => when(
        () => repository.signIn(login: 'operator', password: 'secret'),
      ).thenAnswer((_) async => const Success<User>(_user)),
      build: () => LoginBloc(repository),
      act: (bloc) => bloc
        ..add(const LoginLoginChanged(' operator '))
        ..add(const LoginPasswordChanged('secret '))
        ..add(const LoginSubmitted()),
      skip: 2,
      expect: () => const [
        LoginState(
          login: ' operator ',
          password: 'secret ',
          status: LoginStatus.submitting,
        ),
        LoginState(
          login: ' operator ',
          password: 'secret ',
          status: LoginStatus.success,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'shows the failure when sign-in fails',
      setUp: () => when(
        () => repository.signIn(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Failed<User>(NetworkFailure())),
      build: () => LoginBloc(repository),
      seed: () => const LoginState(login: 'a', password: 'b'),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => const [
        LoginState(login: 'a', password: 'b', status: LoginStatus.submitting),
        LoginState(
          login: 'a',
          password: 'b',
          status: LoginStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );
  });

  group('SessionBloc', () {
    test('follows sign-in, expiry and sign-out', () async {
      final storage = SessionStorage(InMemoryKeyValueStore());
      final bloc = SessionBloc(
        storage: storage,
        repository: AuthRepositoryImpl(_MockAuthRemoteDataSource(), storage),
      );
      expect(bloc.state.isAuthenticated, isFalse);

      await storage.start(token: 'abc', user: _user);
      await pumpEventQueue();
      expect(bloc.state.isAuthenticated, isTrue);
      expect(bloc.state.user, _user);

      await storage.expire('abc');
      await pumpEventQueue();
      expect(bloc.state.isAuthenticated, isFalse);
      expect(bloc.state.endReason, SessionEndReason.expired);

      await storage.start(token: 'def', user: _user);
      bloc.add(const SessionSignOutRequested());
      await pumpEventQueue();
      expect(bloc.state.isAuthenticated, isFalse);
      expect(bloc.state.endReason, SessionEndReason.signedOut);

      await bloc.close();
    });
  });
}
