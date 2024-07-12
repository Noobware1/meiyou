import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextUtils on BuildContext {
  GoRouter get router => GoRouter.of(this);

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  Size get size => MediaQuery.of(this).size;

  EdgeInsets get mediaPadding => MediaQuery.of(this).padding;

  EdgeInsets padding(
      {bool top = true,
      bool bottom = true,
      bool left = true,
      bool right = true,
      EdgeInsets minimum = const EdgeInsets.all(0)}) {
    final padding = MediaQuery.paddingOf(this);
    return EdgeInsets.only(
        left: max(left ? padding.left : 0.0, minimum.left),
        top: max(top ? padding.top : 0.0, minimum.top),
        right: max(right ? padding.right : 0.0, minimum.right),
        bottom: max(bottom ? padding.bottom : 0.0, minimum.bottom));
  }

  bool get isWideScreen => width > 600;

  bool get isSmallScreen => width < 600;

  ThemeData get theme => Theme.of(this);

  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isSystemInDarkMode => brightness == Brightness.dark;

  Uri get currentRoutePath {
    final RouteMatch lastMatch =
        GoRouter.of(this).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : GoRouter.of(this).routerDelegate.currentConfiguration;
    return matchList.uri;
  }
}
