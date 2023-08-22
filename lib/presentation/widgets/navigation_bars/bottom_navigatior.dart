import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/icons.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
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
  }
}
