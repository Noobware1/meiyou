import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/ui/model/app_theme.dart';
import 'package:meiyou/domain/ui/ui_preferences.dart';
import 'package:meiyou/presentation/common/notifers/theme_notifer.dart';
import 'package:meiyou/presentation/core/state_listenable_builder.dart';
import 'package:meiyou/presentation/theme/theme_mode_selector.dart';
import 'package:meiyou/presentation/theme/theme_selector.dart';

import 'package:meiyou_extensions_lib/preference.dart';
import 'package:meiyou/core/utils/resources/storage/storage_preferences.dart';
import 'package:meiyou/presentation/onboard/steps/onboarding_step.dart';
import 'package:meiyou/presentation/core/button.dart';
import 'package:meiyou/presentation/core/space.dart';

class ThemeStep implements OnBoardingStep {
  ThemeStep();

  @override
  VoidCallback? get listener => null;

  @override
  ThemeStepWidget build(BuildContext context) => const ThemeStepWidget();

  @override
  bool get isCompleted => true;
}

class ThemeStepWidget extends OnBoardingStepWidget {
  const ThemeStepWidget({super.key});

  @override
  State<ThemeStepWidget> createState() => _StorageStepState();
}

class _StorageStepState extends State<ThemeStepWidget> {
  late ThemeNotifer themeNotifer;

  @override
  void initState() {
    themeNotifer = getIt.get<ThemeNotifer>();
    super.initState();
  }

  void onThemModeSelected(ThemeMode themeMode) {
    themeNotifer.setThemeMode(themeMode);
  }

  void onThemeSelected(AppTheme appTheme) {
    themeNotifer.setAppTheme(appTheme);
  }

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
        stateListenable: themeNotifer,
        builder: (context, state, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemeModeSelector(
                  borderColor: state.getColorScheme(context).outline,
                  themeMode: state.themeMode,
                  onThemeModeSelected: onThemModeSelected),
              const VerticalSpace(40),
              ThemeSelector(
                currentAppTheme: state.appTheme,
                isAmoled: state.isAmoled,
                themeMode: state.themeMode,
                onThemeSelected: onThemeSelected,
              ),
            ],
          );
        });
  }
}
