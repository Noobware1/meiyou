import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/resources/colors.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/resources/prefrences.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/directory.dart';
import 'package:meiyou/core/utils/show_overlay_widgets.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/app_theme.dart';
import 'package:meiyou/presentation/widgets/arrow_selector_list.dart';
import 'package:meiyou/presentation/widgets/settings/meiyou_switch_button.dart';
import 'package:meiyou/presentation/widgets/settings/theme_preference_widget.dart';
import 'package:meiyou/presentation/widgets/text_inside_text.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPage();
}

class _GeneralPage extends State<GeneralPage> {
  final _titleTextStyle = TextStyle(fontSize: isMobile ? 15 : 18);

  Future<bool>? asyncProcessOnGoing;

  Future<void> runAsync<T>(Future<T> Function() asyncTask) async {
    await asyncProcessOnGoing;
    asyncProcessOnGoing = Future.value(true);
    try {
      await asyncTask.call();
    } catch (_) {}
    asyncProcessOnGoing = null;
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
          title: const Text('General'),
          // elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(20),
              _buildWithPadding(context, Text('Cache', style: headerTextStyle)),
              addVerticalSpace(20),
              TextInsideTextButton(
                  outerText: 'Clear all selected response',
                  innerText: 'used 0mb',
                  onTap: () {
                    AppDirectories.of(context)
                        .savedSelectedResponseDirectory
                        .deleteAllEntries(() => showSnackBAr(context,
                            text: 'Deleted all selected response'));
                  }),
              addVerticalSpace(20),
              TextInsideTextButton(
                  outerText: 'Clear all cache',
                  innerText: 'used 0mb',
                  onTap: () {
                    AppDirectories.of(context)
                        .appCacheDirectory
                        .deleteAllEntries(() =>
                            showSnackBAr(context, text: 'Deleted all cache'));
                  }),
              addVerticalSpace(20),
              MeiyouSwitchButton(
                  onChanged: (value) {},
                  label: 'Delete response cache on exit',
                  initalValue: false)
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
          child: TextInsideText(outerText: outerText, innerText: innerText)),
    );
  }
}
