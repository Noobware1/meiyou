import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/player/notifers/buffering_notifer.dart';
import 'package:meiyou/presentation/player/notifers/player_state_notifer.dart';

import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:nice_dart/nice_dart.dart';

class PlayerPlayPause extends StatefulWidget {
  const PlayerPlayPause({super.key});

  @override
  State<PlayerPlayPause> createState() => _PlayerPlayPauseState();
}

class _PlayerPlayPauseState extends State<PlayerPlayPause>
    with SingleTickerProviderStateMixin {
  static const buttonSize = Size(75.0, 75.0);
  static const ButtonStyle style = ButtonStyle(
    fixedSize: MaterialStatePropertyAll(buttonSize),
    iconSize: MaterialStatePropertyAll(55.0),
    shape: MaterialStatePropertyAll(CircleBorder()),
  );

  late final AnimationController _animationController;
  late final StreamSubscription<bool> _subscription;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300))
      ..forward();

    getIt.playerRepository.let((it) {
      moveAnimation(getIt.playerRepository.isPlaying());
      _subscription =
          getIt.playerRepository.isPlayingStream().listen((playing) {
        moveAnimation(playing);
      });
    });
    super.initState();
  }

  void moveAnimation(bool playing) {
    if (!playing) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetItListenableBuilder<PlayerStateNotifer, PlayerState>(
        builder: (context, state) {
      return GetItListenableBuilder<BufferingNotifer, bool>(
          builder: (context, isBuffering) {
        return SizedBox.fromSize(
          size: buttonSize,
          child: (state == PlayerState.loading || isBuffering)
              ? null
              : IconButton(
                  style: style,
                  onPressed: () {
                    getIt.playerRepository.playOrPause();
                  },
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    size: 55.0,
                    progress: _animationController,
                    color: Colors.white,
                  ),
                ),
        );
      });
    });
  }
}
