import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const home = '/home';
  static const info = '/home/info';
  static const player = '/player';

  static const search = '/search';
  static const libary = '/libary';
  static const plugins = '/plugins';
  static const more = '/more';

  static reslovePlayerRoute(BuildContext context) {
    return GoRouter.of(context).routeInformationProvider.value.uri.path +
        player;
  }
}

class RouteNames {
  static const home = 'home';
  static const info = 'info';
  static const player = 'player';
  static const search = 'search';
  static const libary = 'libary';
  static const more = 'more';
}
