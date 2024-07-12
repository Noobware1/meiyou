import 'package:flutter/material.dart';
import 'package:meiyou/domain/models/navigation_bar_item.dart';
import 'package:meiyou/domain/repositories/navigation_bar_repository.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onDestinationSelected;
  final List<NavigationBarItem> destinations;

  const BottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations.mapList((e) => e.toDestination()),
    );
  }
}

extension on NavigationBarItem {
  NavigationDestination toDestination() {
    return NavigationDestination(
      icon: Icon(icon),
      label: label,
      selectedIcon: selectedIcon == null ? null : Icon(selectedIcon!),
      tooltip: '',
    );
  }
}
