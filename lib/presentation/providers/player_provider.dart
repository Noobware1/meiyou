import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class PlayerProvider {
  final Player player;
  final VideoController controller;

  PlayerProvider({required this.player, required this.controller});

  void dispose() {
    player.dispose();
  }
}

PlayerProvider playerProvider(BuildContext context) {
  return context.repository<PlayerProvider>();
}
