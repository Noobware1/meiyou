import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/constants/icons.dart';

class SideNavigatonBar extends StatelessWidget {
  final GoRouterState goRouterState;

  final StatefulNavigationShell statefulNavigationShell;
  const SideNavigatonBar(
      {super.key,
      required this.goRouterState,
      required this.statefulNavigationShell});

  static _defaultTextStyle(String text) => DefaultTextStyle(
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      child: Text(text));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: NavigationRail(
        selectedIndex: statefulNavigationShell.currentIndex,
        backgroundColor: Colors.black,
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        // unselectedLabelTextStyle: TextStyle(color: Colors.grey),
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
              icon: outlinedIcons[3], label: defaultSizedBox)
        ],
      ),
    );
  }
}
