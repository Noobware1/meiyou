import 'package:flutter/material.dart';
import 'package:meiyou/shared/domain/models/screen_size.dart';

abstract class InheritedResposiveTheme extends InheritedTheme {
  const InheritedResposiveTheme({
    super.key,
    required this.screenSize,
    required super.child,
  });

  final ScreenSize screenSize;

  @override
  bool updateShouldNotify(covariant InheritedResposiveTheme oldWidget) {
    return screenSize != oldWidget.screenSize;
  }
}
