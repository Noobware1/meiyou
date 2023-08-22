import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/icons.dart';
class SideNavigatonBar extends StatelessWidget {
  const SideNavigatonBar({super.key});

  static _defaultTextStyle(String text) => DefaultTextStyle(
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      child: Text(text));

  @override
  Widget build(BuildContext context) {
    return NavigationRail(destinations: [
      NavigationRailDestination(
          icon: outlinedIcons[0], label: _defaultTextStyle('Home')),
      NavigationRailDestination(
          icon: outlinedIcons[1], label: _defaultTextStyle('Search')),
      NavigationRailDestination(
          icon: outlinedIcons[2], label: _defaultTextStyle('My List')),
      NavigationRailDestination(
          icon: outlinedIcons[3], label: _defaultTextStyle('Settings'))
    ], selectedIndex: 0,
    
    
    );
  }
}
