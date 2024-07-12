import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar, Route;

import 'package:go_router/go_router.dart';

import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/modules/base_preferences.dart';
import 'package:meiyou/data/repositories/navigation_bar_repository_impl.dart';
import 'package:meiyou/domain/models/source.dart' hide Source;
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/category/category_screen.dart';
import 'package:meiyou/presentation/history/history_screen.dart';

import 'package:meiyou/presentation/home/home_screen.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/extension_info_screen.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/tabs/install_extension_tab.dart';
import 'package:meiyou/presentation/info/info_screen.dart';
import 'package:meiyou/presentation/more/more_screen.dart';
import 'package:meiyou/presentation/settings/screen/apperance/appearance_settings.dart';
import 'package:meiyou/presentation/settings/screen/library/category_screen.dart';
import 'package:meiyou/presentation/settings/screen/library/library_settings.dart';
import 'package:meiyou/presentation/settings/settings_screen.dart';
import 'package:meiyou/presentation/settings/screen/storage/storage_screen.dart';
import 'package:meiyou/presentation/onboard/onboard_screen.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:meiyou/presentation/library/library_screen.dart';
import 'package:meiyou/presentation/core/multi_nav_scaffold/multi_nav_scaffold.dart';
import 'package:meiyou/presentation/core/navigation_bar/bottom_navigation_bar.dart';
import 'package:meiyou/presentation/core/navigation_bar/side_navigation_bar.dart';
import 'package:meiyou/presentation/search/search_screen.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
// final GlobalKey<NavigatorState> _sectionANavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

class RouterProvider {
  DateTime? lastPressed;

  RouterProvider();

  final _navigationBarRepository = NavigationBarRepositoryImpl();

  GoRouter get router => _router;

  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    overridePlatformDefaultLocation: true,
    initialLocation: getIt.get<BasePreferences>().shownOnboardingFlow().get()
        ? Route.home.path
        : Route.onboarding.path,
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
                  bottomNavigationBar: BBottomNavigationBar(
                    shell: navigationShell,
                    repository: _navigationBarRepository,
                  ),
                  sideNavigatonBar: SSideNavigationBar(
                    shell: navigationShell,
                    repository: _navigationBarRepository,
                  ),
                  body: navigationShell));
        },
        branches: [
          Route.home
              .toStatefulShellBranch((context, state) => const HomeScreen()),
          Route.libary
              .toStatefulShellBranch((context, state) => const LibraryScreen()),
          Route.history
              .toStatefulShellBranch((context, state) => const HistoryScreen()),
          Route.more
              .toStatefulShellBranch((context, state) => const MoreScreen()),
        ],
      ),
      Route.search.toGoRoute((context, state) => const SearchScreen()),
      Route.info.toGoRoute((context, state) =>
          InfoScreen(contentItem: state.extra as ContentItem)),
      Route.player.toGoRoute((context, state) => const PlayerScreen()),
      Route.extensionInfo.toGoRoute((context, state) {
        final (extension, type) =
            state.extra as (InstalledExtension, ExtensionType);
        return ExtensionInfoScreen(
          extension: extension,
          type: type,
        );
      }),
      Route.onboarding.toGoRoute((context, state) => const OnBoardingScreen()),

      /// settings
      Route.settings.toGoRoute((context, state) => const SettingsScreen()),
      Route.storage.toGoRoute((context, state) => const StorageScreen()),
      Route.apperance_settings
          .toGoRoute((context, state) => const ApperanceSettings()),
      Route.librarySettings
          .toGoRoute((context, state) => const LibrarySettings()),
      Route.editCategories.toGoRoute(
          (context, state) => CategoryScreen(initialIndex: state.extra as int)),
    ],
  );
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
