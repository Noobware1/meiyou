import 'package:flutter/material.dart';

extension ContextUtils on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  Size get size => MediaQuery.of(this).size;

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  ThemeData get theme => Theme.of(this);

  Orientation get orientation => MediaQuery.of(this).orientation;
}
