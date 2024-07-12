import 'package:flutter/material.dart';

class NavigationBarItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;

  const NavigationBarItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
  });
}
