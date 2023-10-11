import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/resources/colors.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/resources/prefrences.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/show_overlay_widgets.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/app_theme.dart';
import 'package:meiyou/presentation/widgets/arrow_selector_list.dart';
import 'package:meiyou/presentation/widgets/settings/theme_preference_widget.dart';
import 'package:meiyou/presentation/widgets/text_inside_text.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  final _titleTextStyle = TextStyle(fontSize: isMobile ? 15 : 18);
  // bool _saving = true;
  Future<bool>? _saving;

  _saveTheme(String path, MeiyouThemeState state) async {
   
   await _saving;
    _saving = Future.value(true);
    await saveData(
        savePath: path,
        // ,
        data: jsonEncode(state
            // (BlocProvider.of<ThemeBloc>(context).state as MeiyouThemeState)
            .toJson()),
        // onCompleted: () => showSnackBAr(context, text: 'Updated Theme'),
        onError: (e) => print(e));
    _saving = null;
   
  }

  @override
  Widget build(BuildContext context) {
    // return AppTheme.builder(builder: (context, state) {
    final headerTextStyle = TextStyle(
        color: context.theme.colorScheme.primary,
        fontSize: isMobile ? 15 : 18,
        fontWeight: FontWeight.w400);

    return SafeArea(
      left: false,
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          title: const Text('Appearance'),
          // elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(20),
              _buildWithPadding(context, Text('Theme', style: headerTextStyle)),
              addVerticalSpace(20),
              AppTheme.listenableBuilder(
                listener: (context, state) => _saveTheme(
                    '${RepositoryProvider.of<AppDirectories>(context).settingsDirectory.path}/theme.json',
                    state as MeiyouThemeState),
                builder: (context, state) => TextInsideTextButton(
                  outerText: 'Dark Mode',
                  innerText: _getStringBasedOnThemeMode(state.themeMode),
                  onTap: () {
                    // final bloc = BlocProvider.of<ThemeBloc>(context);
                    showMeiyouDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 300),
                              child: ArrowSelectorList<ThemeMode>(
                                builder: (context, mode) {
                                  return _getStringBasedOnThemeMode(mode);
                                },
                                initalValue: BlocProvider.of<ThemeBloc>(context)
                                    .state
                                    .themeMode,
                                items: const [
                                  ThemeMode.system,
                                  ThemeMode.light,
                                  ThemeMode.dark
                                ],
                                label: 'Dark Mode',
                                onApply: (mode) {
                                  BlocProvider.of<ThemeBloc>(context)
                                      .add(ToggleThemeMode(mode));
                                  context.pop();
                                },
                                onCancel: () {
                                  context.pop();
                                },
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
              addVerticalSpace(20),
              _buildWithPadding(
                context,
                Text(
                  'App Theme',
                  style: _titleTextStyle,
                ),
              ),
              addVerticalSpace(20),
              // const Padding(
              //     padding: EdgeInsets.only(left: 10, right: 10),
              //     child:
              const ThemePreferenceWidget(),
              //),
              if (context.themeBloc.state.themeMode == ThemeMode.dark ||
                  (context.themeBloc.state.themeMode == ThemeMode.system &&
                      context.isDarkMode)) ...[
                addVerticalSpace(20),
                Material(
                  type: MaterialType.button,
                  elevation: 0.0,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<ThemeBloc>(context).add(ToggleAmoledTheme(
                          context.themeBloc.state.isAmoled ? false : true));
                    },
                    child: Row(
                      children: [
                        addHorizontalSpace(20),
                        Expanded(
                            child: Text(
                          'Enable Amoled Mode',
                          style: _titleTextStyle,
                        )),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Switch.adaptive(
                                activeTrackColor: context
                                    .theme.colorScheme.primary
                                    .withOpacity(0.4),
                                inactiveThumbColor: getBaseColorFromThemeMode(
                                    context, context.themeBloc.state.themeMode),
                                inactiveTrackColor: getBaseColorFromThemeMode(
                                        context,
                                        context.themeBloc.state.themeMode)
                                    .withOpacity(0.4),
                                activeColor: context.theme.colorScheme.primary,
                                value: context.themeBloc.state.isAmoled,
                                onChanged: (value) {
                                  BlocProvider.of<ThemeBloc>(context)
                                      .add(ToggleAmoledTheme(value));
                                }),
                          ),
                        ),
                        addHorizontalSpace(10),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
    // });
  }

  Widget _buildWithPadding(BuildContext context, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: child,
    );
  }

  String _getStringBasedOnThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'On';
      case ThemeMode.light:
        return 'Off';

      default:
        return 'Follow System';
    }
  }
}

class TextInsideTextButton extends StatelessWidget {
  final String outerText;
  final String innerText;
  final void Function() onTap;
  const TextInsideTextButton(
      {super.key,
      required this.outerText,
      required this.innerText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.button,
      elevation: 0.0,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: TextInsideText(outerText: outerText, innerText: innerText)
      ),
    );
  }
}
