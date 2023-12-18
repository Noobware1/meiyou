import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/constants/icons.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class SideNavigatonBar extends StatelessWidget {
  final GoRouterState goRouterState;

  final StatefulNavigationShell statefulNavigationShell;
  const SideNavigatonBar(
      {super.key,
      required this.goRouterState,
      required this.statefulNavigationShell});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? 100 : 90,
      child: NavigationRail(
        groupAlignment: -0.6,
        elevation: 8.0,
        selectedIndex: statefulNavigationShell.currentIndex,
        backgroundColor: context.theme.colorScheme.secondary,
        unselectedIconTheme: IconThemeData(
          color: Colors.white54,
          // color: getBaseColorFromThemeMode(context),
        ),
        // unselectedLabelTextStyle:
        //     TextStyle(color: getBaseColorFromThemeMode(context)),
        // selectedLabelTextStyle:
        //     TextStyle(color: context.theme.colorScheme.primary),
        minWidth: isMobile ? 52 : null,

        labelType: NavigationRailLabelType.none,
        onDestinationSelected: (value) =>
            statefulNavigationShell.goBranch(value),
        destinations: [
          NavigationRailDestination(
              icon: outlinedIcons[0], label: defaultSizedBox),
          NavigationRailDestination(
              icon: outlinedIcons[1], label: defaultSizedBox),
          NavigationRailDestination(
              icon: outlinedIcons[2], label: defaultSizedBox),
          NavigationRailDestination(
              icon: outlinedIcons[3], label: defaultSizedBox),
          NavigationRailDestination(
              icon: outlinedIcons[4], label: defaultSizedBox)
        ],
      ),
    );
  }
}
