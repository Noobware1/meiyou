import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/constants.dart';

// BUTTON: PLAY/PAUSE

/// A material design play/pause button.
class MaterialDesktopPlayOrPauseButton extends StatefulWidget {
  /// Overriden icon size for [MaterialDesktopSkipPreviousButton].
  final double? iconSize;

  /// Overriden icon color for [MaterialDesktopSkipPreviousButton].
  final Color? iconColor;

  const MaterialDesktopPlayOrPauseButton({
    super.key,
    this.iconSize,
    this.iconColor,
  });

  @override
  MaterialDesktopPlayOrPauseButtonState createState() =>
      MaterialDesktopPlayOrPauseButtonState();
}

class MaterialDesktopPlayOrPauseButtonState
    extends State<MaterialDesktopPlayOrPauseButton>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    value: playerProvider(context).player.state.playing ? 1 : 0,
    duration: const Duration(milliseconds: 200),
  );

  StreamSubscription<bool>? subscription;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscription ??=
        playerProvider(context).player.stream.playing.listen((event) {
      if (event) {
        animation.forward();
      } else {
        animation.reverse();
      }
    });
  }

  @override
  void dispose() {
    animation.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: playerProvider(context).player.playOrPause,
      iconSize: widget.iconSize ?? buttonBarButtonSize,
      icon: AnimatedIcon(
        progress: animation,
        icon: AnimatedIcons.play_pause,
        size: widget.iconSize ?? buttonBarButtonSize,
      ),
    );
  }
}
