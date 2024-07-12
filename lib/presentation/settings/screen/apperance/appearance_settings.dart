import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/ui/ui_preferences.dart';
import 'package:meiyou/presentation/common/notifers/theme_notifer.dart';
import 'package:meiyou/presentation/core/default_sized_box.dart';
import 'package:meiyou/presentation/core/expandable_text.dart';
import 'package:meiyou/presentation/core/section.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/core/state_listenable_builder.dart';
import 'package:meiyou/presentation/core/switch_list_tile.dart';
import 'package:meiyou/presentation/theme/theme_mode_selector.dart';
import 'package:meiyou/presentation/theme/theme_selector.dart';

class ApperanceSettings extends StatefulWidget {
  const ApperanceSettings({super.key});

  @override
  State<ApperanceSettings> createState() => _ApperanceSettingsState();
}

class _ApperanceSettingsState extends State<ApperanceSettings> {
  late final UiPreferences uiPreferences;
  late final ThemeNotifer themeNotifer;
  @override
  void initState() {
    super.initState();
    uiPreferences = getIt.get<UiPreferences>();
    themeNotifer = getIt.get<ThemeNotifer>();
  }

  @override
  Widget build(BuildContext context) {
    const cornerPadding = EdgeInsets.only(left: 20, right: 20);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: ConstrainedBox(
        // padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: context.height,
          maxWidth: context.width,
        ),
        child: ListView(
          children: [
            StateListenableBuilder(
                stateListenable: themeNotifer,
                builder: (context, state, _) {
                  final brighteness = context.brightness;
                  return Section(title: 'Theme', children: [
                    Padding(
                      padding: Section.defaultPadding,
                      child: ThemeModeSelector(
                          themeMode: state.themeMode,
                          onThemeModeSelected: (themeMode) {
                            themeNotifer.setThemeMode(themeMode);
                          }),
                    ),
                    IgnoreSectionPadding(
                      newPadding: const EdgeInsets.only(top: 20),
                      child: ThemeSelector(
                        padding:
                            EdgeInsets.only(left: Section.defaultPadding.left),
                        currentAppTheme: state.appTheme,
                        isAmoled: state.isAmoled,
                        themeMode: state.themeMode,
                        onThemeSelected: (appTheme) {
                          themeNotifer.setAppTheme(appTheme);
                        },
                      ),
                    ),
                    if (state.themeMode == ThemeMode.dark ||
                        (brighteness == Brightness.dark &&
                            state.themeMode == ThemeMode.system))
                      CustomSwitchListTile(
                        contentPadding: cornerPadding,
                        onChanged: (isEnabled) {
                          themeNotifer.setAmoled(isEnabled);
                        },
                        value: state.isAmoled,
                        title: 'Amoled theme',
                      )
                  ]);
                }),
          ],
        ),
      ),
    );
  }
}
