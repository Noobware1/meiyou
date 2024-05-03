import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/config/routes/routes.dart';
import 'package:meiyou/core/utils/extensions/double.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou_extensions_lib/models.dart';

extension ContextUtils on BuildContext {
  GoRouter get router => GoRouter.of(this);

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  Size get size => MediaQuery.of(this).size;

  bool get isWideScreen => width > 600;

  bool get isSmallScreen => width < 600;

  ScreenSize get screenSize => width.screenSize;

  ThemeData get theme => Theme.of(this);

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isDarkMode =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark;

  Uri get currentRoutePath {
    final RouteMatch lastMatch =
        GoRouter.of(this).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : GoRouter.of(this).routerDelegate.currentConfiguration;
    return matchList.uri;
  }

  void goToInfoScreen(ContentItem item) {
    SubRoutes.info.go(this, extra: item);
  }

  void goToPlayerScreen() {
    SubRoutes.player.go(this);
  }

  void goToHomeScreen() {
    Routes.home.go(this);
  }
}
