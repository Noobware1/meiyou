import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/domain/models/navigation_bar_item.dart';
import 'package:nice_dart/nice_dart.dart';

class SideNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onDestinationSelected;
  final List<NavigationBarItem> destinations;
  const SideNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SizedBox(
      width: 90,
      child: NavigationRail(
        labelType: NavigationRailLabelType.all,
        groupAlignment: -1.0,
        elevation: 8.0,
        selectedIndex: selectedIndex,
        backgroundColor: theme.colorScheme.surface,
        minWidth: 52,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations.mapList((e) => e.toDestination()),
      ),
    );
  }
}

extension on NavigationBarItem {
  NavigationRailDestination toDestination() {
    return NavigationRailDestination(
      icon: Icon(icon),
      label: Text(label),
      selectedIcon: selectedIcon == null ? Icon(selectedIcon) : null,
    );
  }
}
