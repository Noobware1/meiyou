import 'package:flutter/material.dart';
import 'package:meiyou/domain/ui/model/app_theme.dart';
import 'package:meiyou_extensions_lib/preference.dart';

class UiPreferences {
  final PreferenceStore _preferenceStore;

  UiPreferences(this._preferenceStore);

  Preference<ThemeMode> themeMode() => _preferenceStore.getEnum(
      "pref_theme_mode_key", ThemeMode.system, ThemeMode.values);

  Preference<AppTheme> appTheme() => _preferenceStore.getEnum(
        "pref_app_theme",
        AppTheme.deault,
        AppTheme.values,
      );

  Preference<bool> themeDarkAmoled() =>
      _preferenceStore.getBool("pref_theme_dark_amoled_key", false);

  Preference<bool> relativeTime() =>
      _preferenceStore.getBool("relative_time_v2", true);

  Preference<String> dateFormat() =>
      _preferenceStore.getString("app_date_format", "");

  //  tabletUiMode() => _preferenceStore.getEnum("tablet_ui_mode", TabletUiMode.AUTOMATIC);
}
