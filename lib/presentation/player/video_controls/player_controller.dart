import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

class PlayerController extends ChangeNotifier  {
  final Player player;

  bool playing = false;
  bool buffering = false;

  final List<StreamSubscription> _subscriptions = [];

  PlayerController(this.player) {
    _subscriptions.addAll([
      player.stream.playing.listen((event) {
        playing = event;
      }),
      player.stream.buffering.listen((event) {
        buffering = event;
      })

    ]);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
