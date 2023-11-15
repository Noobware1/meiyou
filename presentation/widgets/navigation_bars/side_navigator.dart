import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/themes/utils.dart';
import 'package:meiyou/core/constants/icons.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/resources/colors.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/app_theme.dart';

class SideNavigatonBar extends StatelessWidget {
  final GoRouterState goRouterState;

  final StatefulNavigationShell statefulNavigationShell;
  const SideNavigatonBar(
      {super.key,
      required this.goRouterState,
      required this.statefulNavigationShell});

  @override
  Widget build(BuildContext context) {
    return AppTheme.builder(
        builder: (context, state) => SizedBox(
              width: isMobile ? 120 : 90,
              child: NavigationRail(
                groupAlignment: -0.6,
                elevation: 8.0,
                selectedIndex: statefulNavigationShell.currentIndex,
                backgroundColor: getTheme(context, state).colorScheme.secondary,
                unselectedIconTheme: IconThemeData(
                  color: getBaseColorFromThemeMode(context, state.themeMode),
                ),
                unselectedLabelTextStyle: TextStyle(
                    color: getBaseColorFromThemeMode(context, state.themeMode)),
                selectedLabelTextStyle: TextStyle(
                    color: getTheme(context, state).colorScheme.primary),
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (value) =>
                    statefulNavigationShell.goBranch(value),
                destinations: [
                  NavigationRailDestination(
                      icon: outlinedIcons[0], label: const Text('Home')),
                  NavigationRailDestination(
                      icon: outlinedIcons[1], label: const Text('Search')),
                  NavigationRailDestination(
                      icon: outlinedIcons[2], label: const Text('My List')),
                  NavigationRailDestination(
                      icon: outlinedIcons[3], label: const Text('Settings'))
                ],
              ),
            ));
  }
}
