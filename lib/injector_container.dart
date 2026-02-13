import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rf_id_test/feature/auth/data/remote/auth_remote_data_source.dart';
import 'package:rf_id_test/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:rf_id_test/feature/auth/domain/repository/auth_repository.dart';
import 'package:rf_id_test/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:rf_id_test/feature/home/data/remote/home_remote_data_source.dart';
import 'package:rf_id_test/feature/home/data/repository/home_repository_impl.dart';
import 'package:rf_id_test/feature/home/domain/repository/home_repository.dart';
import 'package:rf_id_test/feature/home/domain/use_case/get_list_use_case.dart';
import 'package:rf_id_test/feature/home/presentation/bloc/home/home_bloc.dart';
import 'package:rf_id_test/feature/home/presentation/bloc/inventory/inventory_bloc.dart';
import 'package:rf_id_test/feature/home/presentation/bloc/marking/marking_bloc.dart';
import 'package:rf_id_test/feature/home/presentation/bloc/products/products_bloc.dart';
import 'package:rf_id_test/feature/new_feature/inventory/repositories/inventory_repository.dart';
import 'package:rf_id_test/feature/new_feature/inventory/services/inventory_service.dart';

import 'app/bloc/app_bloc.dart';
import 'core/api/api_client.dart';
import 'core/base/local_source.dart';
import 'feature/home/presentation/bloc/transistion/transistion_bloc.dart';
import 'feature/new_feature/marking/marking_repository.dart';
import 'feature/new_feature/marking/services/marking_service.dart';
import 'feature/new_feature/movement/movement_repository.dart';
import 'feature/new_feature/movement/services/movement_service.dart';

late final Box<dynamic> _box;
late final LocalSource localSource;
final sl = GetIt.instance;

Future<void> init() async {
  await initHive();

  sl
    ..registerSingleton(InternetConnection())
    ..registerLazySingleton<Dio>(() => ApiClient().getDio)
    ..registerSingleton<LocalSource>(LocalSource(_box))
    ..registerLazySingleton<AppBloc>(() => AppBloc(sl()))
    ..registerLazySingleton(ApiClient.new);

  localSource = sl<LocalSource>();

  _auth();
  _home();
  _inventory();
  _marking();
  _movement();
}

void _auth() {
  sl
    ..registerLazySingleton(() => AuthRemoteDataSource(dio: sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
          remoteDataSource: sl(),
          localSource: localSource,
        ))
    ..registerFactory(() => AuthBloc(repository: sl()));
}

void _home() {
  sl
    ..registerLazySingleton(() => HomeRemoteDataSource(dio: sl()))
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl(), localSource: sl()),
    )
    ..registerFactory(() => GetListUseCase(repository: sl()))
    ..registerFactory<HomeBloc>(() => HomeBloc())
    ..registerFactory<ProductsBloc>(() => ProductsBloc(getListUseCase: sl()))
    ..registerFactory<InventoryBloc>(() => InventoryBloc(getListUseCase: sl()))
    ..registerFactory<MarkingBloc>(() => MarkingBloc())
    ..registerFactory<TransistionBloc>(() => TransistionBloc());
}

Future<void> initHive() async {
  const boxName = 'rf_id_inventory_box';
  final Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  _box = await Hive.openBox<dynamic>(boxName);

  sl.registerSingleton<Box<dynamic>>(_box);
}

void _inventory() {
  sl.registerLazySingleton<InventoryService>(
    () => InventoryService(sl<LocalSource>()),
  );

  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepository(sl<InventoryService>()),
  );
}

void _marking() {
  sl.registerLazySingleton<MarkingService>(
    () => MarkingService(sl<LocalSource>()),
  );

  sl.registerLazySingleton<MarkingRepository>(
    () => MarkingRepository(sl<MarkingService>()),
  );
}

void _movement() {
  sl.registerLazySingleton<MovementService>(
    () => MovementService(),
  );

  sl.registerLazySingleton<MovementRepository>(
    () => MovementRepository(sl<MovementService>()),
  );
}
