import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/combine_stream.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/ui/model/app_theme.dart';
import 'package:meiyou/domain/ui/ui_preferences.dart';
import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou/presentation/theme/meiyou_theme.dart';
import 'package:meiyou/presentation/theme/theme_defaults.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:path/path.dart';

class ThemeNotifer extends StateNotifer<ThemeState> {
  ThemeNotifer() : super(_defaultState()) {
    getIt.get<UiPreferences>().let(
          (it) => CombineStream.combine3(
            it.themeMode().changes(),
            it.appTheme().changes(),
            it.themeDarkAmoled().changes(),
            (themeMode, appTheme, themeDarkAmoled) {
              return _state(themeMode, appTheme, themeDarkAmoled);
            },
            initalDataA: it.themeMode().get(),
            initalDataB: it.appTheme().get(),
            initalDataC: it.themeDarkAmoled().get(),
          ).listen(setState),
        );
  }

  static _defaultState() {
    final preferences = getIt.get<UiPreferences>();
    return _state(
      preferences.themeMode().get(),
      preferences.appTheme().get(),
      preferences.themeDarkAmoled().get(),
    );
  }

  static ThemeState _state(
    ThemeMode themeMode,
    AppTheme appTheme,
    bool isAmoled,
  ) {
    return ThemeState(
      appTheme,
      themeMode,
      MaterialThemeDeaults.to(ThemeData.from(
          colorScheme: getThemeColorScheme(Brightness.light, appTheme, false),
          useMaterial3: true)),
      MaterialThemeDeaults.to(ThemeData.from(
        colorScheme: getThemeColorScheme(Brightness.dark, appTheme, isAmoled),
        useMaterial3: true,
      )),
      isAmoled,
    );
  }

  void setAppTheme(AppTheme appTheme) {
    if (state.appTheme == appTheme) return;
    final preferences = getIt.get<UiPreferences>();
    preferences.appTheme().set(appTheme);
  }

  void setThemeMode(ThemeMode themeMode) {
    if (state.themeMode == themeMode) return;
    final preferences = getIt.get<UiPreferences>();
    preferences.themeMode().set(themeMode);
  }

  void setAmoled(bool isAmoled) {
    if (state.isAmoled == isAmoled) return;
    final preferences = getIt.get<UiPreferences>();
    preferences.themeDarkAmoled().set(isAmoled);
  }
}

class ThemeState {
  final AppTheme appTheme;
  final ThemeMode themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final bool isAmoled;

  const ThemeState(this.appTheme, this.themeMode, this.lightTheme,
      this.darkTheme, this.isAmoled);

  ColorScheme getColorScheme(BuildContext context) {
    return theme(context).colorScheme;
  }

  ThemeData theme(BuildContext context) {
    final Brightness brightness = context.brightness;
    if (themeMode == ThemeMode.dark || brightness == Brightness.dark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }
}
