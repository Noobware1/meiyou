import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/meiyou_elevated_icon_button.dart';

import 'package:meiyou/presentation/widgets/settings/button.dart';
import 'package:meiyou/presentation/widgets/settings/theme_page.dart';
import 'package:meiyou/presentation/widgets/text_inside_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          addVerticalSpace(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              addHorizontalSpace(20),
              Icon(
                Icons.settings_outlined,
                color: context.theme.colorScheme.primary,
                size: isMobile ? 25 : 32,
              ),
              addHorizontalSpace(10),
              Text(
                'Settings',
                style: TextStyle(
                    fontSize: isMobile ? 20 : 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          addVerticalSpace(30),
          MeiyouElevatedIconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Icon(
              Icons.tune_outlined,
              color: context.theme.colorScheme.primary,
            ),
            onTap: () => context.go('/$settings/general'),
            child: const TextInsideText(
                outerText: 'General', innerText: 'App mode, cache'),
          ),
          MeiyouElevatedIconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Icon(
              Icons.palette_outlined,
              color: context.theme.colorScheme.primary,
            ),
            onTap: () => context.go('/$settings/appearance'),
            child: const TextInsideText(
                outerText: 'Appaerance', innerText: 'Theme'),
          ),
          MeiyouElevatedIconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Icon(
              Icons.subtitles_outlined,
              color: context.theme.colorScheme.primary,
            ),
            onTap: () => context.go('/$settings/providers'),
            child: const TextInsideText(
                outerText: 'Providers', innerText: 'Default providers'),
          ),
        ],
      ),
    );
  }
}
