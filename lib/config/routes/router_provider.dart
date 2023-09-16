import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/core/constants/path.dart';
import 'package:meiyou/core/initialization_view/intialise_view_type.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/repositories/video_player_repositoriy_impl.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/usecases/cache_repository_usecases/delete_io_cache_from_dir.dart';
import 'package:meiyou/presentation/pages/home/home_page.dart';
import 'package:meiyou/presentation/pages/search/search_page.dart';
import 'package:meiyou/presentation/player/player.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/widgets/custom_scaffold.dart';
import 'package:meiyou/presentation/widgets/fetch_info.dart';
import 'package:meiyou/presentation/widgets/navigation_bars/bottom_navigatior.dart';
import 'package:meiyou/presentation/widgets/navigation_bars/side_navigator.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellkey = GlobalKey<NavigatorState>();

class MeiyouRouterProvider {
  DateTime? lastPressed;

  GoRouter router() {
    return GoRouter(
        navigatorKey: _rootKey,
        initialLocation: homeRoute,
        routes: [
          StatefulShellRoute.indexedStack(
              builder: (context, state, navigationShell) => CustomScaffold(
                    backgroundColor: Colors.black,
                    bottomNavigationBar: MyBottomNavigationBar(
                        goRouterState: state,
                        statefulNavigationShell: navigationShell),
                    sideNavigatonBar: SideNavigatonBar(
                        goRouterState: state,
                        statefulNavigationShell: navigationShell),
                    body: WillPopScope(
                        child: navigationShell,
                        onWillPop: () async {
                          final now = DateTime.now();
                          const maxDuration = Duration(seconds: 2);
                          if (lastPressed == null ||
                              now.difference(lastPressed!) > maxDuration) {
                            lastPressed = DateTime.now();

                            showSnackBAr(context,
                                text: 'Double tap to exit app');
                            return false;
                          } else {
                            lastPressed = null;
                       

                            return true;
                          }
                        }),
                  ),
              branches: [
                StatefulShellBranch(navigatorKey: _shellkey, routes: [
                  GoRoute(
                      path: homeRoute,
                      name: home,
                      pageBuilder: (context, state) =>
                          const MaterialPage(child: HomePage()),
                      routes: [watchSubRoute]),
                ]),
                StatefulShellBranch(routes: [
                  GoRoute(
                      path: searchRoute,
                      name: search,
                      pageBuilder: (context, state) =>
                          const MaterialPage(child: SearchPage()),
                      routes: [watchSubRoute])
                ]),
                StatefulShellBranch(routes: [
                  GoRoute(
                      path: myListRoute,
                      name: myList,
                      pageBuilder: (context, state) =>
                          const MaterialPage(child: SizedBox()))
                ]),
                StatefulShellBranch(routes: [
                  GoRoute(
                      path: settingsRoute,
                      name: settings,
                      pageBuilder: (context, state) =>
                          const MaterialPage(child: SizedBox()))
                ])
              ])
        ]);
  }

  final watchSubRoute = GoRoute(
      path: 'watch',
      parentNavigatorKey: _rootKey,
      builder: (context, state) => LoadInfo(
          metaResponse: state.extra as MetaResponseEntity,
          type: InitaliseViewType.watchview),
      routes: [
        GoRoute(
            path: 'player',
            parentNavigatorKey: _rootKey,
            builder: (context, state) =>
                ((state.extra as List)[1] as Widget Function(Widget child))
                    .call(
                  RepositoryProvider(
                    create: (context) => VideoPlayerUseCaseContainer(
                        VideoPlayerRepositoryImpl()),
                    child: BlocProvider(
                        create: (context) => SelectedServerCubit(
                            (state.extra as List)[0] as SelectedServer),
                        child: const MeiyouPlayer()),
                  ),
                )),
      ]);
}
