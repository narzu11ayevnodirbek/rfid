import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:rfid/feature/auth/presentation/login/login_page.dart';
import 'package:rfid/feature/home/presentation/bloc/home/home_bloc.dart';
import 'package:rfid/feature/home/presentation/pages/home/home_page.dart';
import 'package:rfid/feature/home/presentation/pages/main/main_page.dart';
import 'package:rfid/presentation/pages/splash/splash_page.dart';
import 'package:rfid/infrastructure/di/injector_container.dart';
import 'package:rfid/presentation/router/route_names.dart';
import 'package:rfid/feature/new_feature/inventory/pages/inventory_page.dart';
import 'package:rfid/feature/new_feature/marking/pages/marking_page.dart';
import 'package:rfid/feature/new_feature/movement/pages/movement_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellRootNavigatorKey = GlobalKey<StatefulNavigationShellState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      name: '/',
      path: '/',
      builder: (_, __) => BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>(),
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      name: Routes.auth,
      path: Routes.auth,
      builder: (_, __) => BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      name: Routes.home,
      path: Routes.home,
      builder: (_, __) => BlocProvider<HomeBloc>(
        create: (context) => sl<HomeBloc>(),
        child: const HomePage(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      key: shellRootNavigatorKey,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __, navShell) => MainPage(navigationShell: navShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.inventory,
              path: Routes.inventory,
              builder: (context, state) => const InventoryPage(),
              routes: [],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.products,
              path: Routes.products,
              builder: (context, state) => const MarkingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.transition,
              path: Routes.transition,
              builder: (context, state) => const MovementPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
