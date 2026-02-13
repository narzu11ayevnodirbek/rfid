import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rf_id_test/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:rf_id_test/feature/auth/presentation/login/login_page.dart';
import 'package:rf_id_test/feature/home/presentation/bloc/home/home_bloc.dart';
// import 'package:rf_id_test/feature/home/presentation/bloc/inventory/inventory_bloc.dart';
// import 'package:rf_id_test/feature/home/presentation/bloc/marking/marking_bloc.dart';
// import 'package:rf_id_test/feature/home/presentation/bloc/products/products_bloc.dart';
// import 'package:rf_id_test/feature/home/presentation/bloc/transistion/transistion_bloc.dart';
import 'package:rf_id_test/feature/home/presentation/pages/home/home_page.dart';
// import 'package:rf_id_test/feature/home/presentation/pages/inventory/inventory_page.dart';
import 'package:rf_id_test/feature/home/presentation/pages/main/main_page.dart';
import 'package:rf_id_test/feature/new_feature/inventory/pages/inventory_page.dart';
import 'package:rf_id_test/feature/new_feature/marking/pages/marking_page.dart';
import 'package:rf_id_test/feature/new_feature/movement/pages/movement_page.dart';
// import 'package:rf_id_test/feature/home/presentation/pages/marking/marking_page.dart';
// import 'package:rf_id_test/feature/home/presentation/pages/products/products_page.dart';
// import 'package:rf_id_test/feature/home/presentation/pages/transition/movement_page.dart';
import 'package:rf_id_test/feature/splash/splash_page.dart';
import 'package:rf_id_test/injector_container.dart';
import 'package:rf_id_test/router/route_names.dart';

import '../feature/home/presentation/pages/inventory/inventory_page.dart';
import '../feature/home/presentation/pages/marking/marking_page.dart';
import '../feature/home/presentation/pages/transition/transition_page.dart';

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
    // GoRoute(
    //   name: Routes.inventory,
    //   path: Routes.inventory,
    //   builder: (_, __) => BlocProvider<InventoryBloc>(
    //     create: (context) => sl<InventoryBloc>(),
    //     child: const InventoryPage(),
    //   ),
    // ),
    // GoRoute(
    //   name: Routes.products,
    //   path: Routes.products,
    //   builder: (_, __) => BlocProvider<ProductsBloc>(
    //     create: (context) => sl<ProductsBloc>(),
    //     child: const ProductsPage(),
    //   ),
    // ),
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
              // builder: (_, __) => BlocProvider<InventoryBloc>(
              //   create: (context) => sl<InventoryBloc>(),
              //   child: const InventoryPage(),
              // ),
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
              // builder: (_, __) => BlocProvider<MarkingBloc>(
              //   create: (context) => sl<MarkingBloc>(),
              //   child: const MarkingPage(),
              // ),
              builder: (context, state) => const MarkingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.transition,
              path: Routes.transition,
              // builder: (_, __) => BlocProvider<TransistionBloc>(
              //   create: (context) => sl<TransistionBloc>(),
              //   child: const TransitionPage(),
              // ),
              builder: (context, state) => const MovementPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
