import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:nice_dart/nice_dart.dart';

part 'player_play_pause_button_mobile.dart';

class PlayerPlayPause extends StatelessWidget {
  final StateStream<bool> stateStream;
  final VoidCallback onPressed;
  const PlayerPlayPause({
    super.key,
    required this.stateStream,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerPlayPauseButtonMobile(
          stateStream: stateStream,
          onPressed: onPressed,
        ),
        desktop: () => const SizedBox(),
      );
    });
  }
}
