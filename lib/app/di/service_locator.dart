import 'package:get_it/get_it.dart';
import 'package:rfid/core/config/app_config.dart';
import 'package:rfid/core/network/api_client.dart';
import 'package:rfid/core/rfid/fake_rfid_reader.dart';
import 'package:rfid/core/rfid/platform_rfid_reader.dart';
import 'package:rfid/core/rfid/rfid_reader.dart';
import 'package:rfid/core/session/session_storage.dart';
import 'package:rfid/core/storage/hive_key_value_store.dart';
import 'package:rfid/core/storage/key_value_store.dart';
import 'package:rfid/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rfid/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rfid/features/auth/domain/repositories/auth_repository.dart';
import 'package:rfid/features/inventory/data/datasources/inventory_local_data_source.dart';
import 'package:rfid/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:rfid/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:rfid/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:rfid/features/item_lookup/data/datasources/item_remote_data_source.dart';
import 'package:rfid/features/item_lookup/data/repositories/item_repository_impl.dart';
import 'package:rfid/features/item_lookup/domain/repositories/item_repository.dart';
import 'package:rfid/features/marking/data/datasources/marking_remote_data_source.dart';
import 'package:rfid/features/marking/data/repositories/marking_repository_impl.dart';
import 'package:rfid/features/marking/domain/repositories/marking_repository.dart';
import 'package:rfid/features/movement/data/datasources/movement_remote_data_source.dart';
import 'package:rfid/features/movement/data/repositories/movement_repository_impl.dart';
import 'package:rfid/features/movement/domain/repositories/movement_repository.dart';
import 'package:rfid/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:rfid/features/settings/domain/repositories/settings_repository.dart';

/// The service locator. Used only inside `lib/app/`: everything else gets
/// its dependencies through constructors, which keeps it testable.
final GetIt sl = GetIt.instance;

/// Registers every dependency of the app. Called once from `bootstrap()`.
///
/// To add a feature: write a `_registerX()` with its data sources and
/// repository, and call it below.
Future<void> setUpServiceLocator() async {
  final store = await HiveKeyValueStore.open();
  final session = SessionStorage(store);

  sl
    ..registerSingleton<KeyValueStore>(store)
    ..registerSingleton<SessionStorage>(session)
    ..registerSingleton<ApiClient>(
      ApiClient.create(
        readToken: () => session.token,
        onUnauthorized: session.expire,
      ),
    )
    ..registerSingleton<RfidReader>(
      AppConfig.useFakeRfidReader
          ? FakeRfidReader(demoInterval: const Duration(milliseconds: 700))
          : PlatformRfidReader(),
    );

  _registerAuth();
  _registerSettings();
  _registerInventory();
  _registerItemLookup();
  _registerMarking();
  _registerMovement();

  // Repositories keep per-user caches; drop them when the user changes.
  session.changes.listen((_) {
    if (!session.isAuthenticated) _resetUserCaches();
  });
}

void _registerAuth() {
  sl
    ..registerLazySingleton(() => AuthRemoteDataSource(sl()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()),
    );
}

void _registerSettings() {
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
}

void _registerInventory() {
  sl
    ..registerLazySingleton(() => InventoryRemoteDataSource(sl()))
    ..registerLazySingleton(() => InventoryLocalDataSource(sl()))
    ..registerLazySingleton<InventoryRepository>(
      () => InventoryRepositoryImpl(sl(), sl()),
    );
}

void _registerItemLookup() {
  sl
    ..registerLazySingleton(() => ItemRemoteDataSource(sl()))
    ..registerLazySingleton<ItemRepository>(() => ItemRepositoryImpl(sl()));
}

void _registerMarking() {
  sl
    ..registerLazySingleton(() => MarkingRemoteDataSource(sl()))
    ..registerLazySingleton<MarkingRepository>(
      () => MarkingRepositoryImpl(sl()),
    );
}

void _registerMovement() {
  sl
    ..registerLazySingleton(() => MovementRemoteDataSource(sl()))
    ..registerLazySingleton<MovementRepository>(
      () => MovementRepositoryImpl(sl(), sl()),
    );
}

void _resetUserCaches() {
  sl
    ..resetLazySingleton<InventoryRepository>()
    ..resetLazySingleton<MarkingRepository>()
    ..resetLazySingleton<MovementRepository>();
}
