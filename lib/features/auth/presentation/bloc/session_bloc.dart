import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/core/session/user.dart';
import 'package:rfid/features/auth/domain/repositories/auth_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required SessionStorage storage,
    required AuthRepository repository,
  })  : _storage = storage,
        _repository = repository,
        super(SessionState.fromStorage(storage)) {
    on<_SessionStorageChanged>(
      (event, emit) => emit(SessionState.fromStorage(_storage)),
    );
    on<SessionSignOutRequested>((event, emit) => _repository.signOut());
    _storageSubscription = _storage.changes.listen(
      (_) => add(const _SessionStorageChanged()),
    );
  }

  final SessionStorage _storage;
  final AuthRepository _repository;
  late final StreamSubscription<void> _storageSubscription;

  @override
  Future<void> close() async {
    await _storageSubscription.cancel();
    return super.close();
  }
}
