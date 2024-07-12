import 'package:flutter/material.dart';

abstract class BaseColorScheme {
  abstract final ColorScheme darkScheme;

  abstract final ColorScheme lightScheme;

  ColorScheme getColorScheme(
    bool isDark,
    bool isAmoled,
  ) {
    if (!isDark) return lightScheme;

    if (!isAmoled) return darkScheme;

    return darkScheme.copyWith(
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
    );
  }
}
