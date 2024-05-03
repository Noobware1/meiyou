import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;

import 'package:go_router/go_router.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/utils/resources/modules/base_preferences.dart';
import 'package:meiyou/data/repositories/navigation_bar_repository_impl.dart';
// import 'package:meiyou/presentation/core/info_screen.dart';
import 'package:meiyou/presentation/home/home_screen.dart';
import 'package:meiyou/presentation/info/info_screen.dart';
import 'package:meiyou/presentation/onboard/onboard_screen.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:meiyou/presentation/screens/library_screen.dart';
import 'package:meiyou/presentation/core/multi_nav_scaffold/multi_nav_scaffold.dart';
import 'package:meiyou/presentation/core/navigation_bar/bottom_navigation_bar.dart';
import 'package:meiyou/presentation/core/navigation_bar/side_navigation_bar.dart';
import 'package:meiyou_extensions_lib/models.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
// final GlobalKey<NavigatorState> _sectionANavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

class RouterProvider {
  DateTime? lastPressed;

  RouterProvider();

  GoRoute get infoSubRoute => GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: SubRoutes.info.path,
        builder: (context, state) =>
            InfoScreen(contentItem: state.extra as ContentItem),
        routes: [
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: SubRoutes.player.path,
            builder: (context, state) => const PlayerScreen(),
          ),
        ],
      );

  List<StatefulShellBranch> get routes => [
        // The route branch for the first tab of the bottom navigation bar.
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            // The screen to display as the root in the first tab of the
            // bottom navigation bar.
            path: Routes.home.path,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
              // return HomeScreen();
            },
            routes: <RouteBase>[infoSubRoute],
          ),
        ]),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
              path: Routes.libary.path,
              builder: (BuildContext context, GoRouterState state) =>
                  const LibraryScreen(),
              // routes: <RouteBase>[_watchSubRoute],
            ),
          ],
        ),
        StatefulShellBranch(
          // navigatorKey: _sectionANavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
              path: Routes.extensions.path,
              builder: (BuildContext context, GoRouterState state) =>
                  Container(),
              // routes: <RouteBase>[_watchSubRoute],
            ),
          ],
        ),
        StatefulShellBranch(
          // navigatorKey: _sectionANavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
              path: Routes.more.path,
              builder: (BuildContext context, GoRouterState state) =>
                  const SizedBox(),
              // routes: <RouteBase>[_watchSubRoute],
            ),
          ],
        ),
      ];

  final _navigationBarRepository = NavigationBarRepositoryImpl();

  GoRouter get router => _router;

  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    overridePlatformDefaultLocation: true,
    initialLocation:
        InjectKtor.get<BasePreferences>().shownOnboardingFlow().get()
            ? Routes.home.path
            : Routes.onboarding.path,
    observers: [BotToastNavigatorObserver()],
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) return;
                final now = DateTime.now();
                const maxDuration = Duration(seconds: 2);
                if (lastPressed == null ||
                    now.difference(lastPressed!) > maxDuration) {
                  lastPressed = DateTime.now();

                  (context, text: 'Double tap to exit app');
                  return;
                } else {
                  lastPressed = null;
                  return Navigator.of(context).pop(true);
                }
              },
              child: MultiNavScaffold(
                  bottomNavigationBar: BottomNavigationBar(
                    shell: navigationShell,
                    repository: _navigationBarRepository,
                  ),
                  sideNavigatonBar: SideNavigationBar(
                    shell: navigationShell,
                    repository: _navigationBarRepository,
                  ),
                  body: navigationShell));
        },
        branches: routes,
      ),
      GoRoute(
        // parentNavigatorKey: _rootNavigatorKey,
        path: Routes.onboarding.path,
        builder: (context, state) => const OnBoardingScreen(),
      ),
    ],
  );
}
