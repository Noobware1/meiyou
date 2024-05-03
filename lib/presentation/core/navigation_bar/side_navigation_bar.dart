import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/domain/models/navigation_bar_item.dart';
import 'package:meiyou/domain/repositories/navigation_bar_repository.dart';
import 'package:nice_dart/nice_dart.dart';
import 'navigation_bar.dart' as navigation_bar;
import 'package:go_router/go_router.dart';

class SideNavigationBar extends StatelessWidget
    implements navigation_bar.NavigationBar {
  @override
  final StatefulNavigationShell shell;
  @override
  final NavigationBarRepository repository;

  const SideNavigationBar({
    super.key,
    required this.shell,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    // : Color(0xffe3e2e6)
// flutter: Color(0xffc4c6d0)
// flutter: Color(0xffc4c6d0)
// flutter:
    final theme = context.theme;
    return SizedBox(
      width: isMobile ? 90 : 80,
      child: NavigationRail(
        labelType: NavigationRailLabelType.all,
        groupAlignment: -0.6,
        elevation: 8.0,
        selectedIndex: shell.currentIndex,
        backgroundColor: theme.colorScheme.surface,
        minWidth: isMobile ? 52 : null,
        onDestinationSelected: shell.goBranch,
        destinations: repository.getIcons().mapList((e) => e.toDestination()),
      ),
    );
  }
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
