import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/domain/models/navigation_bar_item.dart';
import 'package:meiyou/domain/repositories/navigation_bar_repository.dart';
import 'package:meiyou/presentation/core/side_navigation_bar.dart';
import 'package:nice_dart/nice_dart.dart';
import 'navigation_bar.dart' as navigation_bar;
import 'package:go_router/go_router.dart';

class SSideNavigationBar extends SideNavigationBar
    implements navigation_bar.NavigationBar {
  @override
  final StatefulNavigationShell shell;
  @override
  final NavigationBarRepository repository;

  SSideNavigationBar({
    super.key,
    required this.shell,
    required this.repository,
  }) : super(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: shell.goBranch,
          destinations: repository.getIcons(),
        );
}

extension on NavigationBarItem {
  NavigationRailDestination toDestination() {
    return NavigationRailDestination(
      icon: Icon(icon),
      label: Text(label),
      selectedIcon: Icon(selectedIcon),
    );
  }
}
