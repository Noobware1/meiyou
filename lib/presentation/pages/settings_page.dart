import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

import 'package:meiyou/presentation/widgets/settings/button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        addVerticalSpace(50),
        ArrowButton(
          onTap: () {
            context.go('/$settings/appearance');
          },
          text: 'Appearance',
          snackBarString: 'Change Appearance',
        ),
        ArrowButton(
          onTap: () {
            context.go('/$settings/providers');
          },
          text: 'Providers',
          snackBarString: 'Providers',
        )
      ],
    );
  }
}
