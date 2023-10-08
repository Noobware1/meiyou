import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/config/themes/meiyou_theme.dart';

import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/resources/colors.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/app_theme.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

class ThemePreferenceWidget extends StatefulWidget {
  const ThemePreferenceWidget({super.key});

  @override
  State<ThemePreferenceWidget> createState() => _ThemePreferenceWidgetState();
}

class _ThemePreferenceWidgetState extends State<ThemePreferenceWidget> {
  late final ScrollController? controller;

  @override
  void initState() {
    if (!isMobile) {
      controller = ScrollController();
    } else {
      controller = null;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildWithScrollbar(Widget child) {
    if (isMobile) return child;
    return Scrollbar(controller: controller, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme.builder(
      builder: (context, state) {
        return LimitedBox(
          maxHeight: 200,
          child: _buildWithScrollbar(
            MediaQuery.removePadding(
              context: context,
              removeLeft: true,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListView.separated(
                    // primary: ,
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => addHorizontalSpace(8),
                    itemBuilder: (context, index) {
                      final theme = MeiyouTheme.values[index]
                          .getFromThemeMode(context, state.themeMode);
                      return Column(children: [
                        Expanded(
                          child: Material(
                            type: MaterialType.button,
                            color: Colors.transparent,
                            elevation: 0.0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                if (MeiyouTheme.values[index].name !=
                                    state.theme.name) {
                                  print(true);
                                  BlocProvider.of<ThemeBloc>(context).add(
                                      ToggleTheme(MeiyouTheme.values[index]));
                                }
                              },
                              child: Container(
                                height: 100,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color:
                                            (MeiyouTheme.values[index].name ==
                                                    state.theme.name)
                                                ? theme.colorScheme.primary
                                                : getBaseColorFromThemeMode(
                                                    context, state.themeMode),
                                        width: 3),
                                    color: theme.scaffoldBackgroundColor),
                                child: Stack(
                                  children: [
                                    //App Bar
                                    Positioned(
                                        top: 10,
                                        // right: 5,
                                        left: 5,
                                        child: Container(
                                          width: 70,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color:
                                                  theme.colorScheme.onSurface,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                        )),

                                    //Is Selected
                                    if (MeiyouTheme.values[index].name ==
                                        state.theme.name)
                                      Positioned(
                                        top: 10,
                                        right: 5,
                                        child: Container(
                                          //      color: Colors.red,
                                          height: 20,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              // borderRadius: BorderRadius.circular(30),
                                              color: theme.colorScheme.primary),
                                          child: const Icon(
                                            Icons.done,
                                            size: 16,
                                          ),
                                        ),
                                      ),

                                    Positioned(
                                        top: 40,
                                        left: 5,
                                        child: Container(
                                          height: 70,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        )),

                                    Positioned(
                                        top: 43,
                                        left: 7,
                                        child: Container(
                                          height: 20,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 30 / 2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15)),
                                                  color: theme
                                                      .colorScheme.tertiary,
                                                ),
                                              ),
                                              Container(
                                                width: 30 / 2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15)),
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                        bottom: 0,
                                        child: Material(
                                          elevation: 8.0,
                                          type: MaterialType.transparency,
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: theme
                                                    .colorScheme.surfaceVariant,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(
                                                                26))),
                                            height: 30,
                                            width: 120,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                addHorizontalSpace(5),
                                                Container(
                                                  height: 15,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: theme
                                                          .colorScheme.primary),
                                                ),
                                                addHorizontalSpace(5),
                                                Container(
                                                  width: 60,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                      color: theme.colorScheme
                                                          .onSurface,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        addVerticalSpace(5),
                        Text(
                          MeiyouTheme.values[index].name,
                          textAlign: TextAlign.center,
                        )
                      ]);
                    },
                    itemCount: MeiyouTheme.values.length),
              ),
            ),
          ),
        );
      },
    );
  }
}
