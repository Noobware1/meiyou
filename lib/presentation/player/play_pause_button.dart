import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
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

    InjectKtor.playerRepository.let((it) {
      moveAnimation(InjectKtor.playerRepository.isPlaying());
      _subscription =
          InjectKtor.playerRepository.isPlayingStream().listen((playing) {
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
    return StreamBuilder(
        initialData: InjectKtor.playerRepository.isBuffering(),
        stream: InjectKtor.playerRepository.isBufferingStream(),
        builder: (context, snapshot) {
          return SizedBox.fromSize(
            size: buttonSize,
            child: !InjectKtor.playerCubit.isLoaded || snapshot.data!
                ? null
                : IconButton(
                    style: style,
                    onPressed: () {
                      InjectKtor.playerRepository.playOrPause();
                    },
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      size: 55.0,
                      progress: _animationController,
                      // progress: _animationController,
                    ),
                  ),
          );
        });
  }
}
