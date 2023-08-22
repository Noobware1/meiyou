import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/presentation/pages/home/home_page.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellkey = GlobalKey<NavigatorState>();

class RouterProvider {
  GoRouter router() {
    return GoRouter(
        navigatorKey: _rootKey,
        initialLocation: homeRoute,
        routes: [
          StatefulShellRoute.indexedStack(branches: [
            StatefulShellBranch(navigatorKey: _shellkey, routes: [
              GoRoute(
                  parentNavigatorKey: _rootKey,
                  path: homeRoute,
                  name: home,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: HomePage()))
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: searchRoute,
                  name: search,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: HomePage()))
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: myListRoute,
                  name: myList,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: HomePage()))
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: settingsRoute,
                  name: settings,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: HomePage()))
            ])
          ])
        ]);
  }
}
