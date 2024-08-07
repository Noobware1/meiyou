import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/router/route_params.dart';
import 'package:meiyou/core/router/routes.dart';
import 'package:meiyou/features/details/presentation/media_screen.dart';
import 'package:meiyou/features/home/presentation/screens/home/home_screen.dart';
import 'package:meiyou/features/home/presentation/screens/search/search_srceen.dart';
import 'package:meiyou/features/player/presentation/screens/player_screen.dart';
import 'package:meiyou/shared/presentation/widgets/multi_nav_scaffold/multi_nav_scaffold.dart';
import 'package:meiyou/shared/presentation/widgets/navigation_bar/navigation_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class RouterProvider {
  GoRouter get router => _router;

  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    overridePlatformDefaultLocation: true,
    initialLocation: Route.home.path,
    routes: [
      _mainScreenRoutes,
      Route.search.toGoRoute((context, state) {
        final params = SearchScreenRouteParams.fromExtra(state.extra);
        return SearchScreen.fromRouteParams(params: params);
      }),
      Route.media.toGoRoute((context, state) {
        final params = MediaScreenRouteParams.fromExtra(state.extra);
        return MediaScreen.fromRouteParams(params: params);
      }),
      Route.player.toGoRoute((context, state) {
        final params = PlayerScreenRouteParams.fromExtra(state.extra);
        return PlayerScreen.fromRouteParams(params: params);
      }),
    ],
  );

  List<Destination> get _mainScreenDestinations {
    return const [
      Destination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home'),
      Destination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person),
          label: 'Library'),
      Destination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'History'),
      Destination(
          icon: Icon(Icons.more_horiz_outlined),
          selectedIcon: Icon(Icons.more_horiz),
          label: 'More'),
    ];
  }

  Widget _navigationBar(NavigationBarType type, StatefulNavigationShell shell) {
    return CustomNavigationBar(
      destinations: _mainScreenDestinations,
      onDestinationSelected: shell.goBranch,
      selectedIndex: shell.currentIndex,
      type: type,
    );
  }

  StatefulShellRoute get _mainScreenRoutes {
    return StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          return MultiNavScaffold(
            bottomNavigationBar:
                _navigationBar(NavigationBarType.bottom, shell),
            sideNavigatonBar: _navigationBar(NavigationBarType.side, shell),
            body: shell,
          );
        },
        branches: [
          Route.home
              .toStatefulShellBranch((context, state) => const HomeScreen()),
          Route.libary
              .toStatefulShellBranch((context, state) => const Scaffold()),
          Route.history
              .toStatefulShellBranch((context, state) => const Scaffold()),
          Route.more
              .toStatefulShellBranch((context, state) => const Scaffold()),
        ]);
  }
}

extension on Route {
  StatefulShellBranch toStatefulShellBranch(
    Widget Function(BuildContext context, GoRouterState state) builder, {
    List<GoRoute> routes = const [],
  }) {
    return StatefulShellBranch(routes: [
      toGoRoute(builder, useParentNavigator: false, routes: routes),
    ]);
  }

  GoRoute toGoRoute(
    Widget Function(BuildContext context, GoRouterState state) builder, {
    bool useParentNavigator = true,
    List<GoRoute> routes = const [],
  }) {
    return GoRoute(
      name: name,
      path: path,
      parentNavigatorKey: useParentNavigator ? _rootNavigatorKey : null,
      builder: builder,
      routes: routes,
    );
  }

  GoRoute toSubGoRoute(
    Widget Function(BuildContext context, GoRouterState state) builder, {
    List<GoRoute> routes = const [],
  }) {
    return GoRoute(
      path: name,
      builder: builder,
      parentNavigatorKey: _rootNavigatorKey,
      routes: routes,
    );
  }
}
