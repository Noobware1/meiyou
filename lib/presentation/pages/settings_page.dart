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
        mainAxisSize: MainAxisSize.min,
        children: [
          addVerticalSpace(50),
          MeiyouElevatedIconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Icon(
              Icons.palette_outlined,
              color: context.theme.colorScheme.primary,
            ),
            onTap: () => context.go('/$settings/appearance'),
            child: const TextInsideText(
                outerText: 'Appaerance', innerText: 'Theme, Amoled'),
          ),
          MeiyouElevatedIconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Icon(
              Icons.palette_outlined,
              color: context.theme.colorScheme.primary,
            ),
            onTap: () => context.go('/$settings/providers'),
            child: const TextInsideText(
                outerText: 'Providers', innerText: 'default providers'),
          ),
        ],
      ),
    );
  }
}
