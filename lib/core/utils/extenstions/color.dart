import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

extension ColorUtils on Color {
  Color resloveBasedOnThemeMode(BuildContext context, ThemeMode mode) {
    if (mode == ThemeMode.dark || context.isDarkMode) {
      return withOpacity(0.8);
    } else if (mode == ThemeMode.light || !context.isDarkMode) {
      return withOpacity(0.6);
    }
    return this;
  }
}
