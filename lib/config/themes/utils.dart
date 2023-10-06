import 'package:flutter/material.dart';
import 'package:meiyou/config/themes/meiyou_theme.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

ThemeData getTheme(BuildContext context, ThemeState state) {
  return getThemeFromThemeMode(context, state.themeMode, state.theme);
}

ThemeData getThemeFromThemeMode(
    BuildContext context, ThemeMode mode, MeiyouTheme theme) {
  if (mode == ThemeMode.dark) {
    return theme.darkTheme;
  } else if (mode == ThemeMode.light) {
    return theme.lightTheme;
  } else {
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? theme.darkTheme
        : theme.lightTheme;
  }
}
