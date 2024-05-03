import 'package:flutter/material.dart';
import 'package:meiyou/domain/models/navigation_bar_item.dart';
import 'package:meiyou/domain/repositories/navigation_bar_repository.dart';
import 'package:nice_dart/nice_dart.dart';
import 'navigation_bar.dart' as navigation_bar;
import 'package:go_router/go_router.dart';

class BottomNavigationBar extends StatelessWidget
    implements navigation_bar.NavigationBar {
  @override
  final StatefulNavigationShell shell;
  @override
  final NavigationBarRepository repository;

  const BottomNavigationBar({
    super.key,
    required this.shell,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: shell.goBranch,
      destinations: repository.getIcons().mapList((e) => e.toDestination()),
    );
  }
}

extension on NavigationBarItem {
  NavigationDestination toDestination() {
    return NavigationDestination(
      icon: Icon(icon),
      label: label,
      selectedIcon: Icon(selectedIcon),
      tooltip: '',
    );
  }
}
