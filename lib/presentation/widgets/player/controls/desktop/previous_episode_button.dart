import 'package:flutter/material.dart';

// BUTTON: PREV EPISODE BUTTON

/// MaterialDesktop design prev episode button.
class MaterialDesktopPrevEpisodeButton extends StatelessWidget {
  /// Icon for [MaterialDesktopPrevEpisodeButton].
  final Widget? icon;

  /// Overriden icon size for [MaterialDesktopPrevEpisodeButton].
  final double? iconSize;

  /// Overriden icon color for [MaterialDesktopPrevEpisodeButton].
  final Color? iconColor;

  const MaterialDesktopPrevEpisodeButton({
    Key? key,
    this.icon,
    this.iconSize,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: const Icon(Icons.skip_previous_rounded),
        iconSize: iconSize);
  }
}
