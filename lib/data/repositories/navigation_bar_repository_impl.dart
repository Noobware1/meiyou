import 'package:flutter/material.dart';
import 'package:meiyou/domain/models/navigation_bar_item.dart';
import 'package:meiyou/domain/repositories/navigation_bar_repository.dart';

class NavigationBarRepositoryImpl implements NavigationBarRepository {
  @override
  List<NavigationBarItem> getIcons() => const [
        NavigationBarItem(
            icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
        NavigationBarItem(
            icon: Icons.person_outlined,
            selectedIcon: Icons.person,
            label: 'Library'),
        NavigationBarItem(
            icon: Icons.history_outlined,
            selectedIcon: Icons.history,
            label: 'History'),
        NavigationBarItem(
            icon: Icons.more_horiz_outlined,
            selectedIcon: Icons.more_horiz,
            label: 'More'),
      ];
}
