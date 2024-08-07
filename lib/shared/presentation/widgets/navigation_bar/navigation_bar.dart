import 'package:flutter/material.dart';
import 'package:meiyou/shared/presentation/widgets/navigation_bar/navigation_bar_theme.dart';

class CustomNavigationBarData {
  final List<Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final DestinationLabelBehavior labelBehavior;
  final NavigationBarType type;

  const CustomNavigationBarData({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.labelBehavior,
    required this.type,
  });
}

class Destination {
  final Widget icon;

  final Widget? selectedIcon;

  final String label;

  final bool enabled;

  const Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.enabled = true,
  });

  NavigationDestination toNavigationDestination() {
    return NavigationDestination(
      icon: icon,
      selectedIcon: selectedIcon,
      label: label,
    );
  }

  NavigationRailDestination toNavigationRailDestination() {
    return NavigationRailDestination(
      icon: icon,
      selectedIcon: selectedIcon,
      disabled: !enabled,
      label: Text(label),
    );
  }
}

enum NavigationBarType {
  side,
  bottom;
}

enum DestinationLabelBehavior {
  alwaysShow,
  onlyShowSelected,
  hide;

  NavigationDestinationLabelBehavior toNavigationDestinationLabelBehavior() {
    switch (this) {
      case DestinationLabelBehavior.alwaysShow:
        return NavigationDestinationLabelBehavior.alwaysShow;
      case DestinationLabelBehavior.onlyShowSelected:
        return NavigationDestinationLabelBehavior.onlyShowSelected;
      case DestinationLabelBehavior.hide:
        return NavigationDestinationLabelBehavior.alwaysHide;
    }
  }

  NavigationRailLabelType toNavigationRailLabelType() {
    switch (this) {
      case DestinationLabelBehavior.alwaysShow:
        return NavigationRailLabelType.all;
      case DestinationLabelBehavior.onlyShowSelected:
        return NavigationRailLabelType.selected;
      case DestinationLabelBehavior.hide:
        return NavigationRailLabelType.none;
    }
  }
}

class CustomNavigationBar extends StatelessWidget {
  final List<Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final DestinationLabelBehavior? labelBehavior;
  final NavigationBarType type;

  const CustomNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.type,
    this.labelBehavior,
  });

  CustomNavigationBar.fromData({
    super.key,
    required CustomNavigationBarData data,
  })  : destinations = data.destinations,
        selectedIndex = data.selectedIndex,
        onDestinationSelected = data.onDestinationSelected,
        type = data.type,
        labelBehavior = data.labelBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = CustomNavigationBarTheme.of(context);
    final labelBehavior = this.labelBehavior ?? theme.labelBehavior;
    switch (type) {
      case NavigationBarType.bottom:
        return NavigationBar(
          destinations:
              destinations.map((e) => e.toNavigationDestination()).toList(),
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          labelBehavior: labelBehavior.toNavigationDestinationLabelBehavior(),
          backgroundColor: theme.backgroundColor,
          elevation: theme.elevation,
          shadowColor: theme.shadowColor,
          surfaceTintColor: theme.surfaceTintColor,
        );
      case NavigationBarType.side:
        return NavigationRail(
          minWidth: theme.minWidth,
          labelType: theme.labelBehavior.toNavigationRailLabelType(),
          destinations:
              destinations.map((e) => e.toNavigationRailDestination()).toList(),
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: theme.backgroundColor,
          elevation: theme.elevation,
          unselectedIconTheme: theme.unselectedIconTheme,
          selectedIconTheme: theme.selectedIconTheme,
          selectedLabelTextStyle: theme.selectedLabelTextStyle,
          unselectedLabelTextStyle: theme.unselectedLabelTextStyle,
        );
    }
  }
}
