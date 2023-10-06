import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/themes/utils.dart';
// import 'package:meiyou/config/themes/app_themes/app_theme.dart';
import 'package:meiyou/core/constants/icons.dart';
import 'package:meiyou/presentation/widgets/app_theme.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final GoRouterState goRouterState;

  final StatefulNavigationShell statefulNavigationShell;
  const MyBottomNavigationBar(
      {super.key,
      required this.goRouterState,
      required this.statefulNavigationShell});

  @override
  Widget build(BuildContext context) {
    return AppTheme.builder(builder: (context, state) {
      return BottomNavigationBar(
          currentIndex: statefulNavigationShell.currentIndex,
          backgroundColor: getTheme(context, state).colorScheme.secondary,
          useLegacyColorScheme: false,
          selectedIconTheme: IconThemeData(
              color: getTheme(context, state).colorScheme.primary),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
          selectedLabelStyle:
              TextStyle(color: getTheme(context, state).colorScheme.primary),
          onTap: (value) => statefulNavigationShell.goBranch(value),
          iconSize: 25,
          showUnselectedLabels: true,
          showSelectedLabels: true,
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
              label: 'My List',
            ),
            BottomNavigationBarItem(
              icon: outlinedIcons[3],
              label: 'Settings',
            )
          ]);
    });
  }
}
