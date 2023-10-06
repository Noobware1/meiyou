import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/player_utils.dart';

class BuildPlayButton extends StatefulWidget {
  const BuildPlayButton({
    super.key,
  });

  @override
  State<BuildPlayButton> createState() => _BuildPlayButtonState();
}

class _BuildPlayButtonState extends State<BuildPlayButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final StreamSubscription<bool> _subscription;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300))
      ..forward();
    _subscription = player(context).stream.playing.listen((playing) {
      if (!playing) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final button = ;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        player(context).playOrPause();
      },
      child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
          size: 50,
          color: Colors.white),
    );
  }
}
