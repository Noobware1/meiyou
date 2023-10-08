
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/core/initialization_view/intialise_view_type.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/repositories/video_player_repositoriy_impl.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/presentation/pages/home/home_page.dart';
import 'package:meiyou/presentation/pages/search/search_page.dart';
import 'package:meiyou/presentation/pages/settings_page.dart';
import 'package:meiyou/presentation/player/player.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/widgets/app_theme.dart';
import 'package:meiyou/presentation/widgets/custom_scaffold.dart';
import 'package:meiyou/presentation/widgets/info/fetch_info.dart';
import 'package:meiyou/presentation/widgets/navigation_bars/bottom_navigatior.dart';
import 'package:meiyou/presentation/widgets/navigation_bars/side_navigator.dart';
import 'package:meiyou/presentation/widgets/settings/providers.dart';
import 'package:meiyou/presentation/widgets/settings/theme_page.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server/video_server_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

SystemUiOverlayStyle setOverlays(MeiyouThemeState state, BuildContext context) {
  if (state.themeMode == ThemeMode.dark ||
      (state.themeMode == ThemeMode.system && context.isDarkMode)) {
    return state.isAmoled
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.black)
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor:
                state.theme.darkTheme.colorScheme.secondary);
  } else {
    return SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        // statusBarColor: Colors.transparent,
        // statusBarColor: state.theme.lightTheme.colorScheme.background,
        systemNavigationBarColor: state.theme.lightTheme.colorScheme.secondary);
  }
}

class RouterProvider {
  GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/home',
        routes: <RouteBase>[
          StatefulShellRoute.indexedStack(
            builder: (BuildContext context, GoRouterState state,
                StatefulNavigationShell navigationShell) {
              // Return the widget that implements the custom shell (in this case
              // using a BottomNavigationBar). The StatefulNavigationShell is passed
              // to be able access the state of the shell and to navigate to other
              // branches in a stateful way.
              return AppTheme.builder(
                  // listener: (context, state) =>
                  //     setOverlays(state as MeiyouThemeState, context),
                  builder: (context, theme) {
                return AnnotatedRegion(
                  value: setOverlays(theme as MeiyouThemeState, context),
                  child: CustomScaffold(
                      bottomNavigationBar: MyBottomNavigationBar(
                          goRouterState: state,
                          statefulNavigationShell: navigationShell),
                      sideNavigatonBar: SideNavigatonBar(
                          goRouterState: state,
                          statefulNavigationShell: navigationShell),
                      body: navigationShell),
                );
              });
            },
            branches: <StatefulShellBranch>[
              // The route branch for the first tab of the bottom navigation bar.
              StatefulShellBranch(
                navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the first tab of the
                    // bottom navigation bar.
                    path: '/home',
                    builder: (BuildContext context, GoRouterState state) =>
                        const AppTheme(child: Scaffold(body: HomePage())),
                    routes: <RouteBase>[_watchSubRoute],
                  ),
                ],
              ),

              // The route branch for the second tab of the bottom navigation bar.
              StatefulShellBranch(
                // It's not necessary to provide a navigatorKey if it isn't also
                // needed elsewhere. If not provided, a default key will be used.
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the second tab of the
                    // bottom navigation bar.
                    path: '/search',
                    builder: (BuildContext context, GoRouterState state) =>
                        const Scaffold(body: SearchPage()),

                    routes: <RouteBase>[_watchSubRoute],
                  ),
                ],
              ),

              // The route branch for the third tab of the bottom navigation bar.
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the third tab of the
                    // bottom navigation bar.
                    path: '/myiist',
                    builder: (BuildContext context, GoRouterState state) =>
                        const Scaffold(
                      body: SizedBox(),
                    ),
                  ),
                ],
              ),

              // The route branch for the fourth tab of the bottom navigation bar.
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                      // The screen to display as the root in the third tab of the
                      // bottom navigation bar.
                      path: '/settings',
                      builder: (BuildContext context, GoRouterState state) =>
                          const Scaffold(body: SettingsPage()),
                      routes: [
                        GoRoute(
                            path: 'appearance',
                            builder: (context, state) =>
                                const AppearancePage()),
                        GoRoute(
                            path: 'providers',
                            builder: (context, state) => const ProvidersPage())
                      ]),
                ],
              ),
            ],
          ),
        ],
      );

  final _watchSubRoute = GoRoute(
      path: 'watch',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => AppTheme(
            child: LoadInfo(
                key: state.pageKey,
                metaResponse: state.extra as MetaResponseEntity,
                type: InitaliseViewType.watchview),
          ),
      routes: [
        GoRoute(
          path: 'player',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => AppTheme(
            child: ((state.extra as List)[1] as Widget Function(Widget child))
                .call(
              RepositoryProvider(
                key: state.pageKey,
                create: (context) =>
                    VideoPlayerUseCaseContainer(VideoPlayerRepositoryImpl()),
                child: BlocProvider(
                    create: (context) => SelectedServerCubit(
                        (state.extra as List)[0] as SelectedServer),
                    child: const MeiyouPlayer()),
              ),
            ),
          ),
        ),
      ]);
}
