import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meiyou/data/repositories/theme_repository_impl.dart';
// import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

extension ContextUtils on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  Size get size => MediaQuery.of(this).size;

  // Color get primaryColor => Theme.of(this).primaryColor;

  // Color get primaryColorDark => Theme.of(this).primaryColorDark;

  ThemeData get theme => Theme.of(this);

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isDarkMode =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark;

  T repository<T>({bool listen = false}) =>
      RepositoryProvider.of<T>(this, listen: listen);

  T bloc<T extends StateStreamableSource<Object?>>({bool listen = false}) =>
      BlocProvider.of<T>(this, listen: listen);
}
