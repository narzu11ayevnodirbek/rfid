import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/app/di/service_locator.dart';
import 'package:rfid/app/router/stream_listenable.dart';
import 'package:rfid/app/shell/home_shell_page.dart';
import 'package:rfid/core/bloc/load_bloc.dart';
import 'package:rfid/core/routing/app_routes.dart';
import 'package:rfid/features/auth/presentation/bloc/login_bloc.dart';
import 'package:rfid/features/auth/presentation/bloc/session_bloc.dart';
import 'package:rfid/features/auth/presentation/pages/login_page.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_details_bloc.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_list_bloc.dart';
import 'package:rfid/features/inventory/presentation/bloc/inventory_scan_bloc.dart';
import 'package:rfid/features/inventory/presentation/pages/inventory_details_page.dart';
import 'package:rfid/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:rfid/features/inventory/presentation/pages/inventory_scan_page.dart';
import 'package:rfid/features/item_lookup/presentation/bloc/item_lookup_bloc.dart';
import 'package:rfid/features/item_lookup/presentation/pages/item_lookup_page.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_list_bloc.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_tag_bind_bloc.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_task_items_bloc.dart';
import 'package:rfid/features/marking/presentation/bloc/marking_task_list_bloc.dart';
import 'package:rfid/features/marking/presentation/pages/marking_list_page.dart';
import 'package:rfid/features/marking/presentation/pages/marking_tag_bind_page.dart';
import 'package:rfid/features/marking/presentation/pages/marking_task_items_page.dart';
import 'package:rfid/features/marking/presentation/pages/marking_task_list_page.dart';
import 'package:rfid/features/movement/presentation/bloc/free_transfer_bloc.dart';
import 'package:rfid/features/movement/presentation/bloc/movement_scan_bloc.dart';
import 'package:rfid/features/movement/presentation/bloc/movement_task_list_bloc.dart';
import 'package:rfid/features/movement/presentation/pages/free_transfer_page.dart';
import 'package:rfid/features/movement/presentation/pages/movement_scan_page.dart';
import 'package:rfid/features/movement/presentation/pages/movement_task_list_page.dart';
import 'package:rfid/features/settings/presentation/bloc/reader_diagnostics_bloc.dart';
import 'package:rfid/features/settings/presentation/pages/reader_diagnostics_page.dart';
import 'package:rfid/features/settings/presentation/pages/settings_page.dart';

/// Every screen of the app and the bloc it gets.
///
/// Each route creates its bloc with `BlocProvider`, so the bloc lives exactly
/// as long as the screen (a scan bloc stops the reader when it closes).
/// Locations come from [AppRoutes]; detail screens receive ids only.
GoRouter createAppRouter(SessionBloc sessionBloc) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.inventory,
    refreshListenable: StreamListenable(sessionBloc.stream),
    redirect: (context, state) => redirectForSession(
      isSignedIn: sessionBloc.state.isAuthenticated,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginBloc(sl()),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.itemLookup,
        builder: (context, state) => BlocProvider(
          create: (_) => ItemLookupBloc(repository: sl(), reader: sl())
            ..add(const ItemLookupCatalogRequested()),
          child: const ItemLookupPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            HomeShellPage(navigationShell: shell),
        branches: [
          _inventoryBranch(rootNavigatorKey),
          _markingBranch(rootNavigatorKey),
          _movementBranch(rootNavigatorKey),
          _settingsBranch(rootNavigatorKey),
        ],
      ),
    ],
  );
}

/// Signed-out users only see the login screen; signed-in users never do.
/// Returns where to go instead of [location], or `null` to stay.
@visibleForTesting
String? redirectForSession({
  required bool isSignedIn,
  required String location,
}) {
  final isAtLogin = location == AppRoutes.login;
  if (!isSignedIn) return isAtLogin ? null : AppRoutes.login;
  if (isAtLogin) return AppRoutes.inventory;
  return null;
}

StatefulShellBranch _inventoryBranch(GlobalKey<NavigatorState> rootKey) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.inventory,
        builder: (context, state) => BlocProvider(
          create: (_) => InventoryListBloc(sl())..add(const LoadRequested()),
          child: const InventoryListPage(),
        ),
        routes: [
          GoRoute(
            path: ':inventoryId',
            parentNavigatorKey: rootKey,
            builder: (context, state) => BlocProvider(
              create: (_) => InventoryDetailsBloc(
                sl(),
                inventoryId: state.pathParameters['inventoryId']!,
              )..add(const LoadRequested()),
              child: const InventoryDetailsPage(),
            ),
            routes: [
              GoRoute(
                path: 'scan',
                parentNavigatorKey: rootKey,
                builder: (context, state) => BlocProvider(
                  create: (_) => InventoryScanBloc(
                    repository: sl(),
                    reader: sl(),
                    inventoryId: state.pathParameters['inventoryId']!,
                  )..add(const InventoryScanStarted()),
                  child: const InventoryScanPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _markingBranch(GlobalKey<NavigatorState> rootKey) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.marking,
        builder: (context, state) => BlocProvider(
          create: (_) => MarkingListBloc(sl())..add(const LoadRequested()),
          child: const MarkingListPage(),
        ),
        routes: [
          GoRoute(
            path: ':markingId/tasks',
            parentNavigatorKey: rootKey,
            builder: (context, state) => BlocProvider(
              create: (_) => MarkingTaskListBloc(
                sl(),
                markingId: state.pathParameters['markingId']!,
              )..add(const LoadRequested()),
              child: const MarkingTaskListPage(),
            ),
            routes: [
              GoRoute(
                path: ':taskId',
                parentNavigatorKey: rootKey,
                builder: (context, state) => BlocProvider(
                  create: (_) => MarkingTaskItemsBloc(
                    sl(),
                    markingId: state.pathParameters['markingId']!,
                    taskId: state.pathParameters['taskId']!,
                  )..add(const LoadRequested()),
                  child: const MarkingTaskItemsPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'items/:itemId',
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => BlocProvider(
                      create: (_) => MarkingTagBindBloc(
                        repository: sl(),
                        reader: sl(),
                        markingId: state.pathParameters['markingId']!,
                        taskId: state.pathParameters['taskId']!,
                        itemId: state.pathParameters['itemId']!,
                      )..add(const MarkingTagBindItemRequested()),
                      child: const MarkingTagBindPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _movementBranch(GlobalKey<NavigatorState> rootKey) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.movement,
        builder: (context, state) => BlocProvider(
          create: (_) => MovementTaskListBloc(sl())..add(const LoadRequested()),
          child: const MovementTaskListPage(),
        ),
        routes: [
          GoRoute(
            path: 'tasks/:taskId/scan',
            parentNavigatorKey: rootKey,
            builder: (context, state) => BlocProvider(
              create: (_) => MovementScanBloc(
                repository: sl(),
                reader: sl(),
                taskId: state.pathParameters['taskId']!,
              )..add(const MovementScanTaskRequested()),
              child: const MovementScanPage(),
            ),
          ),
          GoRoute(
            path: 'free-transfer',
            parentNavigatorKey: rootKey,
            builder: (context, state) => BlocProvider(
              create: (_) => FreeTransferBloc(repository: sl(), reader: sl())
                ..add(const FreeTransferLocationsRequested()),
              child: const FreeTransferPage(),
            ),
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _settingsBranch(GlobalKey<NavigatorState> rootKey) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: 'reader',
            parentNavigatorKey: rootKey,
            builder: (context, state) => BlocProvider(
              create: (_) => ReaderDiagnosticsBloc(sl())
                ..add(const ReaderDiagnosticsStarted()),
              child: const ReaderDiagnosticsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
