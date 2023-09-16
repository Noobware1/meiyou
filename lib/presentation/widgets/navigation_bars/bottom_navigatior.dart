import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/icons.dart';

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
        backgroundColor: Colors.black,
        // selectedIconTheme: const IconThemeData(color: Colors.pi),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        onTap: (value) => statefulNavigationShell.goBranch(value),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            label: '',

            icon: outlinedIcons[0],
            // label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            label: '',
            icon: outlinedIcons[1],
            // label: 'Search',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            label: '',

            icon: outlinedIcons[2],
            // label: 'My List',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            label: '',

            icon: outlinedIcons[3],
            // label: 'Settings',
          )
        ]);
  }
}
