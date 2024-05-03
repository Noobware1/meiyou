import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

enum Routes {
  home('/home'),
  libary('/libary'),
  extensions('/extensions'),
  more('/more'),
  onboarding('/onboarding');

  const Routes(this.path);
  final String path;

  void go(BuildContext context, {Object? extra}) {
    context.router.go(path, extra: extra);
  }
}

enum SubRoutes {
  info('info', '/home/info'),
  player('player', '/home/info/player');

  const SubRoutes(this.path, this.fullPath);

  final String path;
  final String fullPath;

  void go(BuildContext context, {Object? extra}) {
    context.router.push(fullPath, extra: extra);
  }
}
