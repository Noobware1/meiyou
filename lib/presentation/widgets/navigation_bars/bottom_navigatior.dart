import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/icons.dart';
import 'package:meiyou/core/resources/colors.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final GoRouterState goRouterState;

  final StatefulNavigationShell statefulNavigationShell;
  const MyBottomNavigationBar(
      {super.key,
      required this.goRouterState,
      required this.statefulNavigationShell});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: statefulNavigationShell.currentIndex,
        backgroundColor: context.theme.colorScheme.secondary,
        useLegacyColorScheme: false,
        selectedIconTheme:
            IconThemeData(color: context.theme.colorScheme.primary),
        unselectedIconTheme:
            IconThemeData(color: getBaseColorFromThemeMode(context)),
        onTap: (value) => statefulNavigationShell.goBranch(value),
        iconSize: 25,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: outlinedIcons[0],
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: outlinedIcons[1],
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: outlinedIcons[2],
            label: 'Libary',
          ),
          BottomNavigationBarItem(
            icon: outlinedIcons[3],
            label: 'Plugins',
          ),
          BottomNavigationBarItem(
            icon: outlinedIcons[4],
            label: 'Settings',
          )
        ]);
  }
}
