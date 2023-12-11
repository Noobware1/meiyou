import 'package:flutter/material.dart';

// BUTTON: NEXT EPISODE BUTTON

/// MaterialDesktop design next episode button.
class MaterialDesktopNextEpisodeButton extends StatelessWidget {
  /// Icon for [MaterialDesktopNextEpisodeButton].
  final Widget? icon;

  /// Overriden icon size for [MaterialDesktopNextEpisodeButton].
  final double? iconSize;

  /// Overriden icon color for [MaterialDesktopNextEpisodeButton].
  final Color? iconColor;

  const MaterialDesktopNextEpisodeButton({
    super.key,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: const Icon(Icons.skip_next_rounded),
        iconSize: iconSize);
  }
}
