import 'package:flutter/material.dart';
import 'package:meiyou/domain/models/navigation_bar_item.dart';
import 'package:meiyou/domain/repositories/navigation_bar_repository.dart';

class NavigationBarRepositoryImpl implements NavigationBarRepository {
  
  static const icons = [
    NavigationBarItem(
        icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    NavigationBarItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Library'),
    NavigationBarItem(
        icon: Icons.extension_outlined,
        selectedIcon: Icons.extension,
        label: 'Extensions'),
    NavigationBarItem(
        icon: Icons.more_horiz_outlined,
        selectedIcon: Icons.more_horiz,
        label: 'More'),
  ];

  @override
  List<NavigationBarItem> getIcons() => icons;
}
