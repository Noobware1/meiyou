import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/presentation/pages/home_page.dart' as home;
import 'package:meiyou/presentation/pages/info_page.dart';
import 'package:meiyou/presentation/pages/libary_page.dart';
import 'package:meiyou/presentation/pages/player_page.dart';
import 'package:meiyou/presentation/pages/plugins_page.dart';
import 'package:meiyou/presentation/pages/search_page.dart';
import 'package:meiyou/presentation/pages/settings_page.dart';
import 'package:meiyou/presentation/providers/player_dependencies.dart';
import 'package:meiyou/presentation/widgets/custom_scaffold.dart';
import 'package:meiyou/presentation/widgets/navigation_bars/bottom_navigatior.dart';
import 'package:meiyou/presentation/widgets/navigation_bars/side_navigator.dart';
import 'package:meiyou_extensions_lib/models.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

// SystemUiOverlayStyle setOverlays(MeiyouThemeState state, BuildContext context) {
//   if (state.themeMode == ThemeMode.dark ||
//       (state.themeMode == ThemeMode.system && context.isDarkMode)) {
//     return state.isAmoled
//         ? SystemUiOverlayStyle.dark.copyWith(
//             statusBarBrightness: Brightness.light,
//             statusBarIconBrightness: Brightness.light,
//             systemNavigationBarColor: Colors.black)
//         : SystemUiOverlayStyle.dark.copyWith(
//             statusBarBrightness: Brightness.light,
//             statusBarIconBrightness: Brightness.light,
//             systemNavigationBarColor:
//                 state.theme.darkTheme.colorScheme.secondary);
//   } else {
//     return SystemUiOverlayStyle.light.copyWith(
//         statusBarBrightness: Brightness.dark,
//         statusBarIconBrightness: Brightness.dark,
//         // statusBarColor: Colors.transparent,
//         // statusBarColor: state.theme.lightTheme.colorScheme.background,
//         systemNavigationBarColor: state.theme.lightTheme.colorScheme.secondary);
//   }
// }

typedef PlayerDependecyInjector = Widget Function(
    {required BuildContext context, required Widget child});

class RouterProvider {
  DateTime? lastPressed;

  final _infoRoute = GoRoute(
    parentNavigatorKey: _rootNavigatorKey,
    path: RouteNames.info,
    builder: (context, state) {
      return InfoPage(searchResponse: state.extra as SearchResponse);
    },
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.player,
        builder: (context, state) {
          return (state.extra as PlayerDependenciesProvider)
              .injector(const PlayerPage());
        },
      )
    ],
  );

  GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: Routes.home,
        routes: <RouteBase>[
          StatefulShellRoute.indexedStack(
            builder: (BuildContext context, GoRouterState state,
                StatefulNavigationShell navigationShell) {
              return WillPopScope(
                  onWillPop: () async {
                    final now = DateTime.now();
                    const maxDuration = Duration(seconds: 2);
                    if (lastPressed == null ||
                        now.difference(lastPressed!) > maxDuration) {
                      lastPressed = DateTime.now();

                      showSnackBar(context, text: 'Double tap to exit app');
                      return false;
                    } else {
                      lastPressed = null;

                      return true;
                    }
                  },
                  child: CustomScaffold(
                      bottomNavigationBar: MyBottomNavigationBar(
                          goRouterState: state,
                          statefulNavigationShell: navigationShell),
                      sideNavigatonBar: SideNavigatonBar(
                          goRouterState: state,
                          statefulNavigationShell: navigationShell),
                      body: navigationShell));
            },
            branches: <StatefulShellBranch>[
              // The route branch for the first tab of the bottom navigation bar.
              StatefulShellBranch(
                  // navigatorKey: _sectionANavigatorKey,
                  routes: <RouteBase>[
                    GoRoute(
                      // The screen to display as the root in the first tab of the
                      // bottom navigation bar.
                      path: Routes.home,
                      builder: (BuildContext context, GoRouterState state) =>
                          home.HomePage(key: state.pageKey),
                      routes: <RouteBase>[
                        _infoRoute,
                        // _searchRoute,
                      ],
                    ),
                  ]),
              StatefulShellBranch(
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the first tab of the
                    // bottom navigation bar.
                    path: Routes.search,
                    builder: (BuildContext context, GoRouterState state) =>
                        SearchPage(key: state.pageKey),
                    routes: <RouteBase>[
                      _infoRoute,
                      // _searchRoute,
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                // navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the first tab of the
                    // bottom navigation bar.
                    path: Routes.libary,
                    builder: (BuildContext context, GoRouterState state) =>
                        LibaryPage(key: state.pageKey),
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
                    path: Routes.plugins,
                    builder: (BuildContext context, GoRouterState state) =>
                        PluginsPage(key: state.pageKey),
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
                    path: Routes.more,
                    builder: (BuildContext context, GoRouterState state) =>
                        SettingsPage(key: state.pageKey),
                    // routes: <RouteBase>[_watchSubRoute],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
