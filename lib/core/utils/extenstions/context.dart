import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/utils/try_catch.dart';
// import 'package:meiyou/data/repositories/theme_repository_impl.dart';
// import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

extension ContextUtils on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  Size get size => MediaQuery.of(this).size;

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

  T repository<T>({bool listen = false}) =>
      RepositoryProvider.of<T>(this, listen: listen);

  T bloc<T extends StateStreamableSource<Object?>>({bool listen = false}) =>
      BlocProvider.of<T>(this, listen: listen);

  T? tryRepository<T>({bool listen = false}) =>
      trySync(() => RepositoryProvider.of<T>(this, listen: listen));

  T? tryBloc<T extends StateStreamableSource<Object?>>({bool listen = false}) =>
      trySync(() => BlocProvider.of<T>(this, listen: listen));
}
