import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/player/playing_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';

class PlayButtonMobile extends StatefulWidget {
  const PlayButtonMobile({
    super.key,
  });

  @override
  State<PlayButtonMobile> createState() => _PlayButtonMobileState();
}

class _PlayButtonMobileState extends State<PlayButtonMobile>
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
    _subscription = context.bloc<PlayingCubit>().stream.listen((playing) {
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
    return SizedBox(
      height: 45.0,
      width: 45.0,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),

        style:
            const ButtonStyle(shape: MaterialStatePropertyAll(CircleBorder())),
        onPressed: () {
          playerProvider(context).player.playOrPause();
        },
        // alignment: Alignment.center,
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          size: 45.0,
          progress: _animationController,
        ),
      ),
    );
  }
}
